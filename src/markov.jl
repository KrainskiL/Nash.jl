#################################
# Markov chains for game theory #
#################################

"""
    game2markov(game::Dict{String,<:Array}, s::Vector{Vector{T}}) where T<:Real

Returns Markov chain of a given game and given vector of action probabilities

**Input parameters**
* `game::Dict{String,<:Array}` - dictionary of players and their payoff matrices
* `s::Vector{Vector{T}}` - collection of actions probabilities for each player
"""
function game2markov(game::Dict{String,<:Array},
                    s::Vector{Vector{T}}) where T<:Real
    # problem: 2 players
    permuts = permutations( vcat(1, fill(0, size(s[1])[1]-1 )) ) |> collect |> unique
    grid_exp = Iterators.product(collect(permuts),collect(permuts)) |> collect
    to_states = Dict(string(i) => collect(grid_exp[i]) for i in 1:length(grid_exp))
    to_states_inv = Dict(collect(grid_exp[i]) => i for i in 1:length(grid_exp))

    trans = Matrix(0I, length(to_states), length(to_states))
    for i in 1:length(to_states)
        indx = Nash._next_state(game, to_states[string(i)], to_states_inv)
        trans[i, indx] = 1/length(indx) # distributed equally when more than 1 best reply
    end

    init = Array(1:length(to_states))
    mc = MarkovChain(trans, init)
    return mc
end

"""
    plot_markov(no_steps::Int, mc::MarkovChain{Int,Array{Int,2},Array{Int,1}})

Plots a path of Markov chain simulation of a given time length and all initial values

**Input parameters**
* `no_steps::Int` - scalar of time length (number of iterations)
* `mc::MarkovChain{Int,Array{Int,2},Array{Int,1}}` - Markov chain of a game (game2markov output function)
"""
function plot_markov(no_steps::Int,
        mc::MarkovChain{Int,Array{Int,2},Array{Int,1}})
    no_states = stationary_distributions(mc)[1] |> length
    for i in 1:no_states
        line = simulate(mc, 10, init = i)
        i == 1 ? display(plot(1:no_steps, line, label = string(i), lw = 2)) : display(plot!(line, label = string(i), lw = 2))
    end
end