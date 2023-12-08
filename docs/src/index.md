VoronoiFVM.jl
===============

VoronoiFVM.jl is a solver for coupled nonlinear partial differential equations (elliptic-parabolic conservation laws).
The discretization is based on the [Voronoi finite volume method](https://j-fu.github.io/VoronoiFVM.jl/stable/method).
VoronoiFVM.jl supports various flux laws, reaction terms and boundary conditions.
It uses automatic differentiation via [ForwardDiff.jl](https://github.com/JuliaDiff/ForwardDiff.jl) and [DiffResults.jl](https://github.com/JuliaDiff/DiffResults.jl) to evaluate user functions along with their jacobians and calculate derivatives of solutions with respect to their parameters.

## Recent changes
Please look up the list of recent [changes](https://j-fu.github.io/VoronoiFVM.jl/stable/changes) for some breaking changes

## Accompanying packages
- [VoronoiFVMDiffEq.jl](https://github.com/j-fu/VoronoiFVMDiffEq.jl): Glue package for using VoronoiFVM with DifferentialEquations.jl
- [ExtendableSparse.jl](https://github.com/j-fu/ExtendableSparse.jl): convenient and efficient sparse matrix assembly
- [ExtendableGrids.jl](https://github.com/j-fu/ExtendableGrids.jl): unstructured grid management library
- [SimplexGridFactory.jl](https://github.com/j-fu/SimplexGridFactory.jl): unified high level  mesh generator interface
- [Triangulate.jl](https://github.com/JuliaGeometry/Triangulate.jl):  Julia wrapper for the [Triangle](https://www.cs.cmu.edu/~quake/triangle.html) triangle mesh generator by J. Shewchuk
- [TetGen.jl](https://github.com/JuliaGeometry/TetGen.jl):  Julia wrapper for the [TetGen](http://www.tetgen.org) tetrahedral mesh generator by H. Si.
- [GridVisualize.jl](https://github.com/j-fu/GridVisualize.jl): grid and function visualization related to ExtendableGrids.jl
- [PlutoVista.jl](https://github.com/j-fu/PlutoVista.jl): backend for [GridVisualize.jl](https://github.com/j-fu/GridVisualize.jl) for use in Pluto notebooks.

VoronoiFVM.jl and most of these packages are  part of the meta package [PDELib.jl](https://github.com/WIAS-BERLIN/PDELib.jl).


# Papers and preprints using this package

Please consider a pull request if you have published work which could be added to this list.


```@bibliography
*
```


```@raw html
<html>
    <body>
        <script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>
        <script type="module">
            import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs';
            mermaid.initialize({ startOnLoad: true, theme: 'dark', securityLevel: 'loose', htmlLabels: true, });
        </script>
        <div class="mermaid">
            ---
            title: VoronoiFVM.jl Package Ecosystem
            ---
            flowchart TB
                grids["grids"] ==> |"dispatch to"| wrappers["wrappers"]
                pdes["<br>"] ==> |"uses for meshing and assembly"| grids
                gridvis["gridvis"] ==> |"uses interface"| grids
                pdes === |"use for visualization"| gridvis
                subgraph grids["Grid Interface"]
                    eg["ExtendableGrids.jl"]
                    sgf["SimplexGridFactory.jl"]
                    click eg href "https://github.com/j-fu/ExtendableGrids.jl" "Link to ExtendableGrids.jl"
                    click sgf href "https://github.com/j-fu/SimplexGridFactory.jl" "Link to SimplexGridFactory.jl"
                end
                subgraph wrappers["Triangulation Wrappers"]
                    triang["Triangulate.jl"]
                    tetgen["TetGen.jl"]
                    click triang href "https://github.com/JuliaGeometry/Triangulate.jl" "Link to Triangulate.jl"
                    click tetgen href "https://github.com/JuliaGeometry/TetGen.jl" "Link to TetGen.jl"
                end
                subgraph pdes["PDE Discretization and Solution"]
                    vfvm[/"VoronoiFVM.jl"\]
                    click vfvm href "https://github.com/j-fu/VoronoiFVM.jl" "Link to VoronoiFVM.jl"
                end
                subgraph gridvis["Visualization"]
                    direction BT
                    plotbackends["plotbackends"] ==> |"do the plotting for"| gvis["GridVisualize.jl"]
                    click gvis href "https://github.com/j-fu/GridVisualize.jl" "Link to GridVisualize.jl"
                    subgraph plotbackends
                        pvista[/"PlutoVista.jl"\]
                        glmakie[/"Makie.jl"\]
                        plots[/"Plots.jl"\]
                        pyplot[/"PyPlot.jl"\]
                        click pvista href "https://github.com/j-fu/PlutoVista.jl" "Link to PlutoVista.jl"
                        click glmakie href "https://github.com/MakieOrg/Makie.jl" "Link to Makie.jl"
                        click pyplot href "https://github.com/JuliaPy/PyPlot.jl" "Link to PyPlot.jl"
                        click plots href "https://github.com/JuliaPlots/Plots.jl" "Link to Plots.jl"
                    end
                end
        </div>
    </body>
</html>
```






## Some alternatives
- [GradientRobustMultiPhysics.jl](https://github.com/chmerdon/GradientRobustMultiPhysics.jl): finite element library implementing gradient robust FEM
  from the same package base by Ch. Merdon
- [SkeelBerzins.jl](https://github.com/gregoirepourtier/SkeelBerzins.jl): a Julian variation on Matlab's `pdepe` API
- [Trixi.jl](https://github.com/trixi-framework/Trixi.jl):  numerical simulation framework for hyperbolic conservation laws
- [GridAP.jl](https://github.com/gridap/Gridap.jl) Grid-based approximation of partial differential equations in Julia
- [Ferrite.jl](https://github.com/Ferrite-FEM/Ferrite.jl) Finite element toolbox for Julia
- [FinEtools.jl](https://github.com/PetrKryslUCSD/FinEtools.jl)  Finite element tools for Julia
- [FiniteVolumeMethod.jl](https://github.com/DanielVandH/FiniteVolumeMethod.jl/) Finite volumes with Donald boxes
## Citation

If you use this package in your work, please cite it according to [CITATION.cff](https://raw.githubusercontent.com/j-fu/VoronoiFVM.jl/master/CITATION.cff)
