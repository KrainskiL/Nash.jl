
"""
    get_payoff(game::Dict{String,<:AbstractArray}, s::Vector{Vector{T}}) where T<:Real

Produces payoff profile for given game and actions probabilities array

**Input parameters**
* `game::Dict{String,<:AbstractArray}` - array of vectors to use in outer product
* `s::Vector{Vector{T}}` - collection of actions probabilities for each player in a game
"""
function get_payoff(game::Dict{String,<:AbstractArray},
                s::Vector{Vector{T}}) where T<:Real
    if !all(@. round(sum(s),digits = 2) ==1)
        error("Provided vectors are not probabilities distribution")
    end
    return Dict(k=>sum(v.*outer(s)) for (k,v) in game)
end

"""
    best_reply(game::Dict{String,<:Array}, s::Vector{Vector{T}} where T<:Real,
    k::Int, epsil::F=0.0 ;return_val::String = "array") where F<:Real

Returns best reply of given player to actions of his counterparts
(defined by strategy profile) in the form of array or convex hull

**Input parameters**
* `game::Dict{String,<:Array}` - dictionary of players and their payoff matrices
* `s::Vector{Vector{T}} where T<:Real` - collection of actions probabilities for each player in a game
* `k::Int` - player for which the best reply is returned
* `epsil::F = 0.0` - probability of error (if the answer is disturbed)
* `return_val::String = "array"` - type of returned value ("array" or "chull")
"""
function best_reply(game::Dict{String,<:Array},
            s::Vector{Vector{T}} where T<:Real,
            k::Int,
            epsil::F = 0.0;
            return_val::String="array") where F<:Real

    (epsil < 0 || epsil > 1) && throw(ArgumentError("Probability of error (epsil) should be in range 0-1")) && return nothing

    action_no = size(game["player1"])[k]
    s_temp = deepcopy(s)
    payoffs = Vector{Real}()
    for i in 1:length(s_temp[k])
        s_temp[k] = zeros(length(s[k]))
        s_temp[k][i] = 1
        push!(payoffs, get_payoff(game, s_temp)["player"*string(k)])
    end
    eyemat = Matrix(1I, action_no, action_no)
    (epsil != 0 && rand() < epsil) ? pos = rand([false true], action_no) : pos = (payoffs .== maximum(payoffs))
    all(pos .== 0) ? pos[rand(1:action_no)] = 1 : nothing
    val2ret = eyemat[pos, :]
    if return_val == "chull"
        polyh = polyhedron(vrep(val2ret), CDDLib.Library())
        return convexhull(polyh, polyh)
    else
        return val2ret
    end
end

"""
    is_nash_q(game::Dict{String,<:Array}, s::Vector{Vector{T}}) where T<:Real

Returns a dictionary of logical vectors indicating whether given profile is Nash equilibrium.

**Input parameters**
* `game::Dict{String,<:Array}` - dictionary of players and their payoff matrices
* `s::Vector{Vector{T}})` - collection of actions probabilities for each player
"""
function is_nash_q(game::Dict{String,<:Array},
                s::Vector{Vector{T}}) where T<:Real

    nashqs = Dict{String,Bool}()
    for k in 1:length(game)
        st = s[k]
        br = best_reply(game, s, k, return_val = "chull")
        polyh = polyhedron(vrep([st]), CDDLib.Library())
        pint = intersect(br, polyh)
        nashqs["player"*string(k)] = (npoints(pint) != 0)
    end
    nashqs["Nash"] = all(values(nashqs))
    return nashqs
end

"""
    iterate_best_reply(game::Dict{String,<:Array},
            s::Vector{Vector{T}} where T<:Real,
            epsil::F = 0.0, it_num::Int = 10)  where F<:Real

Returns an array of arrays representing each players'
game strategies (action probabilities) history in every iteration

**Input parameters**
* `game::Dict{String,<:Array}` - dictionary of players and their payoff matrices
* `s::Vector{Vector{T}} where T<:Real` - collection of actions probabilities for each player
* `epsil::F = 0.0` - probability of error (if the answer is disturbed)
* `it_num::Int = 10` - an integer specifying how many iterations should be repeated
"""
function iterate_best_reply(game::Dict{String,<:Array},
    s::Vector{Vector{T}} where T<:Real,
    epsil::F = 0.0,
    it_num::Int = 10)  where F<:Real #TODO epsil not default
    s_temp = deepcopy(s)
    s_history = [] #TODO not Any type
    push!(s_history, s_temp)
    for i in 1:it_num
        br = Array{Int64}[]
        for i in 1:length(game)
            push!(br, best_reply(game, s_temp, i, epsil))
        end
        s_temp = _select_random(game, s_temp, br)
        push!(s_history, s_temp)
    end
    println("After ", it_num, " iterations")
    all(values(is_nash_q(game, s_history[length(s_history)]))) ?
        println("Nash equilibrium found") : println("Nash equilibrium not found")
    return s_history
end