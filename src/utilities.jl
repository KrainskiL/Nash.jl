######################
# Auxilary functions #
######################

"""
    outer(vecs::Array{Array{T,1},1}) where T<:Real

Takes vector of vectors and return outer product tensor

**Input parameters**
* `vecs::Array{Array{T,1},1}` - array of vectors to use in outer product
"""
function outer(vecs::Array{Array{T,1},1}) where T<:Real
    vecs_len = length.(vecs)
    dims = length(vecs_len)
    reshaped = [ones(Int,dims) for i in 1:dims]
    for i in 1:dims
        reshaped[i][i]=vecs_len[i]
    end
    return .*([reshape(v,reshaped[i]...) for (i,v) in enumerate(vecs)]...)
end


"""
    outer(vecs::Array{Array{SymPy.Sym,1},1})

Takes vector of symbolic vectors and return outer product tensor

**Input parameters**
* `vecs::Array{Array{SymPy.Sym,1},1}` - array of symbolic vectors to use in outer product
"""
function outer(vecs::Array{Array{SymPy.Sym,1},1})
    vecs_len = length.(vecs)
    dims = length(vecs_len)
    reshaped = [ones(Int,dims) for i in 1:dims]
    for i in 1:dims
        reshaped[i][i]=vecs_len[i]
    end
    return .*([reshape(v,reshaped[i]...) for (i,v) in enumerate(vecs)]...)
end


"""
    _next_state(game::Dict{String,<:Array}, s::Vector{Vector{T}},
            states_dict::Dict{<:Array, Int64}) where T<:Real

Internal function finding the index of next state (next simplex vertex)

**Input parameters**
* `game::Dict{String,<:Array}` - dictionary of players and their payoff matrices
* `s::Vector{Vector{T}},` - vector of actions probabilities
* `states_dict::Dict{<:Array, Int64}` - a dictionary of simplex vertices (states)
"""
function _next_state(game::Dict{String,<:Array},
            s::Vector{Vector{T}},
            states_dict::Dict{<:Array, Int64}) where T<:Real
    br = Array{Int64}[]
    for i in 1:length(game)
        push!(br,best_reply(game, s, i))
    end
    next = _select_random(game, s, br)
    get(states_dict, next, 0)
end

"""
    select_random(game::Dict{String,<:Array}, s::Vector{Vector{T}},
            br::Array{Array{Int64}}) where T<:Real

Internal function for best reply iteration.
Returns a random point on the given best reply simplex

**Input parameters**
* `game::Dict{String,<:Array}` - dictionary of players and their payoff matrices
* `s::Vector{Vector{T}}` - vector of actions probabilities
* `br::Array{Array{Int64}}` - array of best reply
"""
function _select_random(game::Dict{String,<:Array},
            s::Vector{Vector{T}},
            br::Array{Array{Int64}}) where T<:Real
    s_iter = [] #TODO: not Any type
    for i in 1:length(game)
            s_iter_temp = fill(0.0, size(s[i]))' #size: number of actions
            findzero = mapslices(sum, convert(Array{Int,2},br[i]), dims = 1)
            s_iter_temp[findzero .!= 0] = rand(sum(findzero))  #where best reply is non-zero
            s_iter_temp = s_iter_temp ./ sum(s_iter_temp)
            s_iter_temp = reshape(s_iter_temp, size(s[i]))
            push!(s_iter, s_iter_temp)
    end
    s_iter = convert(typeof(s), s_iter)
    return s_iter
end

"""
    plot_br(br::CDDLib.Polyhedron{T}) where T<:Real

Plots best reply in the form of simplex (3d and above)

**Input parameters**
* `br::CDDLib.Polyhedron{T})` - best_reply function (with return_val="chull") output
"""
function plot_br(br::CDDLib.Polyhedron{T}) where T<:Real
    br_mesh=Polyhedra.Mesh(br)
    vis = MeshCat.Visualizer()
    setobject!(vis, br_mesh)
    IJuliaCell(vis)
end
#TODO make stable for 1d, 2d https://github.com/rdeits/MeshCat.jl/blob/master/notebooks/demo.ipynb
