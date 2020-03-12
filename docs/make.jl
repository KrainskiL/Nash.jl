using Documenter

try
    using Nash
catch
    if !("../src/" in LOAD_PATH)
       push!(LOAD_PATH,"../src/")
       @info "Added \"../src/\"to the path: $LOAD_PATH "
       using Nash
    end
end

makedocs(
    sitename = "Nash.jl",
    format = format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true"
    ),
    modules = [Nash],
    pages = ["index.md", "reference.md"],
    doctest = true
)



deploydocs(
    repo ="github.com/KrainskiL/Nash.jl.git",
    target="build"
)