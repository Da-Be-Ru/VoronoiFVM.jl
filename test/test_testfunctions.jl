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

function calc_transfer(n = 5, coordsystem = Cartesian2D)
    @assert n > 3
    X = geomspace(0.0, 1.0, 2.0^(3 - n), 2.0^(-n))
    Y = linspace(0.0, 1.0, 2^n)

    grid = simplexgrid(X, Y)
    if coordsystem == Cylindrical2D
        circular_symmetric!(grid)
    end
    system = VoronoiFVM.System(grid; flux = flux!, bcondition = bcondition!, species = [1])
    _ = solve(system)

    testfuncfac = VoronoiFVM.TestFunctionFactory(system)
    tfc_rea = testfunction(testfuncfac, [1 3 4], [2])

    U = unknowns(system)
    U[1, :] .= map((x, y) -> (x), grid)

    I = VoronoiFVM.integrate(system, tfc_rea, U)

    return I, system, U, tfc_rea
end

function runtests()
    I, _ = calc_transfer(5, Cartesian2D)
    @test I[1] ≈ 1.0 atol = 1.0e-1

    I, _ = calc_transfer(5, Cylindrical2D)
    @test I[1] ≈ 2π atol = 1.0e-1

    return nothing
end
end
