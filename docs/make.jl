using Documenter, ExampleJuggler, PlutoStaticHTML, VoronoiFVM, DocumenterCitations
using ExtendableGrids, GridVisualize, LinearAlgebra, OrdinaryDiffEq, RecursiveArrayTools, SciMLBase
using Pkg

function make(; with_examples = true,
              with_notebooks = true)

    bib = CitationBibliography(
        joinpath(@__DIR__, "src", "citations.bib");
        style=:numeric
    )
    
    ExampleJuggler.verbose!(true)

    cleanexamples()
    notebookdir = joinpath(@__DIR__, "..", "pluto-examples")
    exampledir = joinpath(@__DIR__, "..", "examples")

    size_threshold_ignore=[]

    pages = [
        "Home" => "index.md",
        "changes.md",
        "method.md",
        "API Documentation" => [
            "system.md",
            "physics.md",
            "solutions.md",
            "solver.md",
            "post.md",
            "quantities.md",
            "misc.md",
            "internal.md",
            "allindex.md",
            "devel.md",]
    ]

    
    if with_notebooks
        notebooks = [
            "OrdinaryDiffEq.jl nonlinear diffusion" =>   "ode-diffusion1d.jl",
            "OrdinaryDiffEq.jl 1D wave equation" =>    "ode-wave1d.jl",
            "OrdinaryDiffEq.jl changing mass matrix" =>     "ode-nlstorage1d.jl",
            "OrdinaryDiffEq.jl brusselator"  =>   "ode-brusselator.jl",
            "Outflow boundary conditions" => "outflow.jl",
            "Obtaining vector fields" => "flux-reconstruction.jl",
            "Internal interfaces (1D)" => "interfaces1d.jl",
            "A case for caution" => "problemcase.jl",
            "Nonlinear solver control" => "nonlinear-solvers.jl",
            "API Updates" => "api-update.jl",
            "Coupling with Catalyst.jl" => "heterogeneous-catalysis.jl",
        ]
        notebook_examples = @docplutonotebooks(notebookdir, notebooks, iframe=false)
        notebook_examples = vcat(["About the notebooks" => "notebooks.md"], notebook_examples)
        size_threshold_ignore = last.(notebook_examples)
        push!(pages, "Tutorial Notebooks" => notebook_examples)
    end

    if with_examples
        modules = filter(ex -> splitext(ex)[2] == ".jl", basename.(readdir(exampledir)))
        module_examples = @docmodules(exampledir, modules, use_module_titles=true)
        module_examples = vcat(["About the examples" => "runexamples.md"], module_examples)
        push!(pages, "Examples" => module_examples)
    end

    mathjax_config = Dict(
        :tex => Dict(
            "inlineMath" => [["\$","\$"], ["\\(","\\)"]],
            "tags" => "ams",
            "packages" => ["base", "ams", "autoload", "mhchem"],
        ),
    )
    mathjax_url = extract_mathjax_url(;iframe=false)

    makedocs(; sitename = "VoronoiFVM.jl",
             modules = [VoronoiFVM],
             plugins = [bib],
             checkdocs = :all,
             clean = false,
             doctest = false,
             warnonly = true,
             authors = "J. Fuhrmann",
             repo = "https://github.com/j-fu/VoronoiFVM.jl",
             format = Documenter.HTML(; size_threshold_ignore,
                                       assets=String["assets/citations.css"],
                                      mathengine = MathJax3(mathjax_config,url=mathjax_url)),
             pages)

    
    cleanexamples()

    if !isinteractive()
        deploydocs(; repo = "github.com/j-fu/VoronoiFVM.jl.git")
    end
end

function extract_mathjax_url(;iframe=false)
    editor_html_path = nothing
    if iframe
        # find source directory of transitive Pluto dependency through PlutoSliderServer
        deps = Pkg.dependencies()
        plutosliderserver_uuid = findfirst(x->x.name=="PlutoSliderServer", deps)
        if isnothing(plutosliderserver_uuid)
            @warn "Please import/use PlutoSliderServer.jl to extract Pluto notebooks with `iframe=true`"
        else
            # read the frontend/editor.html which contains the link to the correct MathJax source script
            editor_html_path = get_editor_html_path(plutosliderserver_uuid,deps)
        end        
    else
        # find source directory of transitive Pluto dependency through PlutoStaticHTML 
        deps = Pkg.dependencies()
        plutostatichtml_uuid = findfirst(x->x.name=="PlutoStaticHTML", deps)
        if isnothing(plutostatichtml_uuid)
            @warn "Please import/use PlutoStaticHTML.jl in order to deploy Pluto notebooks with `iframe=false`"
        else
            editor_html_path = get_editor_html_path(plutostatichtml_uuid,deps)
        end
    end

    mathjax_link = read_mathjax_url_from_editor_file(editor_html_path)    

    return mathjax_link
end

function get_editor_html_path(direct_dep_uuid,deps)
    transitive_deps = deps[direct_dep_uuid].dependencies
    pluto_uuid = transitive_deps["Pluto"]
    pluto_pkginfo = deps[pluto_uuid]    
    pluto_source_dir=pluto_pkginfo.source
    editor_html_path = joinpath(pluto_source_dir,"frontend","editor.html")

    return editor_html_path
end

function read_mathjax_url_from_editor_file(editor_html_path)
    # fallback default version 3.2.2
    mathjax_link = "https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/tex-svg-full.js"

    if isnothing(editor_html_path)
        @warn "Could not determine MathJax source from dependencies! Falling back to $mathjax_link ."
        return mathjax_link
    end

    mathjax_script_regex = r"<script type=\"text/javascript\" id=\"MathJax-script\".* not-the-src-yet=\"(?<link>.+)\".*></script>"
    m = nothing
    for line in eachline(editor_html_path)
        m=match(mathjax_script_regex,line)
        isnothing(m) && continue
        mathjax_link = m[:link]
        break
    end

    if isnothing(m)
        @warn "Could not determine MathJax source from dependencies! Falling back to $mathjax_link ."
    end

    return mathjax_link
end

if isinteractive()
    make(; with_examples = false, with_notebooks = false)
else
    make(; with_examples = true, with_notebooks = true)
end
