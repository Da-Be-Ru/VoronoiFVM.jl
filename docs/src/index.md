````@eval
using Markdown
Markdown.parse("""
$(read("../../README.md",String))
""")
````

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
