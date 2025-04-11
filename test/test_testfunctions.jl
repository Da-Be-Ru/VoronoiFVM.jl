module test_testfunctions
using VoronoiFVM
using ExtendableGrids
using Test
using LinearAlgebra

function flux!(f, u, edge, data)
    f[1] = u[1, 1] - u[1, 2]
    return nothing
end

function bcondition!(f, u, bnode, data)
    boundary_dirichlet!(f, u, bnode; species = 1, region = 1, value = 0.0)
    boundary_dirichlet!(f, u, bnode; species = 1, region = 2, value = 1.0)
    return nothing
end

function calc_transfer(n = 5, coordsystem = Cartesian2D, boundary = 2)
    @assert n > 3
    # adaptively refine towards the boundary
    X = geomspace(0.0, 1.0, 2.0^(3 - n), 2.0^(-n))
    Y = linspace(0.0, 1.0, 2^n)

    if boundary == 2
        grid = simplexgrid(X, Y)
    elseif boundary == 3
        grid = simplexgrid(Y, X)
    end

    # the specific shape/values of the test function does not
    # play a role and therefore it doesn't matter on which
    # coordinate system we generate it
    #if coordsystem == Cylindrical2D
    #    circular_symmetric!(grid)
    #end
    system = VoronoiFVM.System(grid; flux = flux!, bcondition = bcondition!, species = [1])
    VoronoiFVM._complete!(system) # compute nodefactors/edgefactors

    testfuncfac = VoronoiFVM.TestFunctionFactory(system)
    tfc_rea = testfunction(testfuncfac, setdiff(1:4, [boundary]), [boundary])
    coords = grid[Coordinates]
    if coordsystem == Cylindrical2D
        tfc_rea .*= coords[1, :]
        # only necessary if we change the coordinate system of the grid
        #cartesian!(grid)
        #system.is_complete = false # retrigger computation of edgefactors/nodefactors
        #VoronoiFVM._complete!(system)
    end

    U = unknowns(system)
    if boundary == 2
        U[1, :] .= map((x, y) -> (x), grid)
    elseif boundary == 3
        # should be 0 for Cylindrical2D, but doesn't work; look at both methods
        #U[1, :] .= map((x, y) -> (x), grid)
        U[1, :] .= map((x, y) -> (y), grid)
    end

    I = VoronoiFVM.integrate(system, tfc_rea, U)

    if coordsystem == Cylindrical2D
        I .*= 2π
    end

    return I, system, U, tfc_rea
end

function runtests()
    I, _ = calc_transfer(6, Cartesian2D, 2)
    @test I[1] ≈ 1.0 atol = 1.0e-1

    I, _ = calc_transfer(6, Cartesian2D, 3)
    @test I[1] ≈ 1.0 atol = 1.0e-1

    I, _ = calc_transfer(6, Cylindrical2D, 2)
    @test I[1] ≈ 2π atol = 1.0e-1

    I, _ = calc_transfer(6, Cylindrical2D, 3)
    @test I[1] ≈ π atol = 1.0e-1

    return nothing
end
end
