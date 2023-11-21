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
                end
                subgraph wrappers["Triangulation Wrappers"]
                    triang["Triangulate.jl"]
                    tetgen["TetGen.jl"]
                end
                subgraph pdes["PDE Discretization and Solution"]
                    vfvm[/"VoronoiFVM.jl"\]
                end
                subgraph gridvis["Visualization"]
                    direction BT
                    plotbackends["plotbackends"] ==> |"do the plotting for"| gvis["GridVisualize.jl"]
                    subgraph plotbackends
                        pvista[/"PlutoVista.jl"\]
                        glmakie[/"Makie.jl"\]
                        plots[/"Plots.jl"\]
                        pyplot[/"PyPlot.jl"\]
                    end
                end
        </div>
    </body>
</html>
```
