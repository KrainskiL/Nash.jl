using Distributions
using LinearAlgebra
using CDDLib
using Polyhedra
using MeshCat
using Combinatorics
using IterTools
using QuantEcon
using Plots


"""
`generate_game` return given payoff matrices for given number
of players with given number of actions

**Input parameters**
* `payoffm` - payoff matrix
"""
function generate_game(payoffm...)
    !all(@. collect(payoffm) isa Array{<: Real}) && return @error "All arguments have to be arrays"
    !all(y->y==size.(payoffm)[1], size.(payoffm)) && return @error "All arrays should have same dimension"
    !all(size.(payoffm) .|> length .== length(payoffm)) && return @error "Dimensions of payoff matrices should equal to number of players (input arguments)"
    Dict("player"*string(i)=>collect(payoffm)[i] for i in 1:length(payoffm))
end

g = generate_game([1 0; 0 1], [1 0; 0 1])

"""
`random_2players_game` return random payoff matrices for 2 players with given number of actions

**Input parameters**
* `dist` - distribution from which payoffs are sampled
* `p1_size` - number of actions of first player
* `p2_size` - number of actions of second player
"""
function random_2players_game(dist::Distributions.Sampleable,
                            p1_size::Int,
                            p2_size::Int)
    return Dict("player"*string(i)=>rand(dist, p1_size, p2_size) for i in 1:2)
end

"""
`random_nplayers_game` return random payoffs for n players with given number of actions

**Input parameters**
* `dist` - distribution from which payoffs are sampled
* `size` - vector or tuple of number of players' actions
"""
function random_nplayers_game(dist::Distributions.Sampleable,
                            size::Union{Array{Int,1},Tuple})
    return Dict("player"*string(i)=>rand(dist, size...) for i in 1:length(size))
end

game = random_nplayers_game(Binomial(5,0.5),[2,3,3]);
game["player1"]


"""
`outer` takes vector of vectors and return outer product tensor

**Input parameters**
* `vecs` - array of vectors to use in outer product
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
`get_payoff` produce payoff profile for given game and actions probabilities array

**Input parameters**
* `game` - array of vectors to use in outer product
* `s` - vector of actions probabilities
"""
function get_payoff(game::Dict{String,<:Array}, s::Vector{Vector{T}}) where T<:Real
    if !all(@. round(sum(s),digits = 2) ==1)
        error("Provided vectors are not probabilities distribution")
    end
    return Dict(k=>sum(v.*outer(s)) for (k,v) in game)
end

game = random_nplayers_game(Binomial(5,0.5),[2,2]);
s = [[0.5,0.5],[0.75,0.25]]
s[1]'*game["player2"]*s[2]
get_payoff(game,s)

"""
`best_reply` return best reply of given player to actions of his counterparts
(defined by strategy profile) in the form of array or convex hull

**Input parameters**
* `game` - dictionary of players and their payoff matrices
* `s` - vector of actions probabilities
* `k` - number of player for which the best reply is returned
* `epsil` - probability of error (if the answer is disturbed)
* `return_val` - type of returned value ("array" or "chull")
"""
function best_reply(game::Dict{String,<:Array}, s::Vector{Vector{T}} where T<:Real,
    k::Int, epsil::F=0.0 ;return_val::String="array") where F<:Real
    (epsil < 0 || epsil > 1) && throw(ArgumentError("Probability of error (epsil) should be in range 0-1"))
    #TODO error should exit function
    action_no = size(game["player1"])[k]
    s_temp=deepcopy(s)
    payoffs=[] #TODO not Any type
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
        return convexhull(polyh,polyh)
    else return val2ret
    end
end


a1 = best_reply(generate_game([1 0; 0 1], [1 0; 0 1]), [[1.0, 0.0], [1, 0]], 1, 0.5) # perturbation epsil=0.5
a2 = best_reply(generate_game(Matrix(I,3,3), Matrix(I,3,3)), [[1/2,1/2,0],[1/3,1/3,1/3]], 1, return_val = "chull") # no perturbation

"""
`is_nash_q` return a dictionary of logical vectors indicating whether
given profile is Nash equilibrium.

**Input parameters**
* `game` - dictionary of players and their payoff matrices
* `s` - vector of actions probabilities
"""
function is_nash_q(game::Dict{String,<:Array}, s::Vector{Vector{T}}) where T<:Real
    nashqs=Dict{String,Bool}()
    for k in 1:length(game)
        st = s[k]
        br = best_reply(game, s, k, return_val="chull")
        polyh = polyhedron(vrep([st]), CDDLib.Library())
        pint = intersect(br, polyh)
        nashqs["player"*string(k)] = (npoints(pint) != 0)
    end
    nashqs
    nashqs["Nash"] = all(values(nashqs))
    return nashqs
end

is_nash_q(generate_game([1 0 ; 0 1], [1 0; 0 1]), [[1, 0], [1, 0]])

"""
`plot_br` plot best reply in the form of simplex (3d and above)

**Input parameters**
* `br` - best_reply function (with return_val="chull") output
"""
function plot_br(br::CDDLib.Polyhedron{T}) where T<:Real
    br_mesh=Polyhedra.Mesh(br)
    vis = MeshCat.Visualizer()
    setobject!(vis, br_mesh)
    IJuliaCell(vis)
end
#TODO make stable for 1d, 2d https://github.com/rdeits/MeshCat.jl/blob/master/notebooks/demo.ipynb

plot_br(a2)

"""
`_select_random` internal function for best reply iteration
return a random point on the given best reply simplex

**Input parameters**
* `game` - dictionary of players and their payoff matrices
* `s` - vector of actions probabilities
* `br` - array of best reply
"""
function _select_random(game::Dict{String,<:Array}, s::Vector{Vector{T}},
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
`iterate_best_reply` return an array of arrays representing each players'
game strategies (action probabilities) history in every iteration

**Input parameters**
* `game` - dictionary of players and their payoff matrices
* `s` - vector of actions probabilities
* `it_num` - an integer specifying how many iterations should be repeated
"""
function iterate_best_reply(game::Dict{String,<:Array}, s::Vector{Vector{T}} where T<:Real,
    epsil::F=0.0, it_num::Int=10)  where F<:Real #TODO epsil not default
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

game = generate_game(Matrix(I, 3, 3), Matrix(I, 3, 3))
s = [[1/2,1/2, 0], [1/3,1/3,1/3]]
game_history = iterate_best_reply(game, s, 1/3, 7) # perturbation epsil=1/3

"""
`_next state` internal function finding the index of next state
(next simplex vertex)

**Input parameters**
* `game` - dictionary of players and their payoff matrices
* `s` - vector of actions probabilities
* `states_dict` - a dictionary of simplex vertices (states)
"""
function _next_state(game::Dict{String,<:Array}, s::Vector{Vector{T}},
    states_dict::Dict{<:Array, Int64}) where T<:Real
    br = Array{Int64}[]
    for i in 1:length(game)
        push!(br,best_reply(game, s, i))
    end
    next = _select_random(game, s, br)
    get(states_dict, next, 0)
end

"""
`game2markov` return Markov chain of a given game and given vector of action
probabilities

**Input parameters**
* `game` - dictionary of players and their payoff matrices
* `s` - vector of actions probabilities
"""
function game2markov(game::Dict{String,<:Array}, s::Vector{Vector{T}}) where T<:Real
    # problem: 2 players
    permuts = permutations( vcat(1, fill(0, size(s[1])[1]-1 )) ) |> collect |> unique
    grid_exp = Iterators.product(collect(permuts),collect(permuts)) |> collect
    to_states = Dict(string(i) => collect(grid_exp[i]) for i in 1:length(grid_exp))
    to_states_inv = Dict(collect(grid_exp[i]) => i for i in 1:length(grid_exp))

    trans = Matrix(0I, length(to_states), length(to_states))
    for i in 1:length(to_states)
        indx = _next_state(game, to_states[string(i)], to_states_inv)
        trans[i, indx] = 1/length(indx) # distributed equally when more than 1 best reply
    end

    init = Array(1:length(to_states))
    mc = MarkovChain(trans, init)
    return mc
end

game = generate_game(Matrix(1I, 3, 3), Matrix(I, 3, 3))
s = [[1, 0, 0],[0, 1, 0]]
mc = game2markov(game, s)
simulate(mc, 9, init = 3)
simulate(mc, 9) # random initial condition

is_irreducible(mc) # can we reach any state from any other state?
communication_classes(mc)
period(mc)
is_aperiodic(mc)
stationary_distributions(mc)
# TODO AS wizualizacja grafow
# TODO AS zaburzenia

"""
`plot_markov` plots a path of Markov chain simulation of a given time length
and all initial values

**Input parameters**
* `no_steps` - scalar of time length (number of iterations)
* `mc` - Markov chain of a game (game2markov output function)
"""
function plot_markov(no_steps::Int64,
    mc::MarkovChain{Int64,Array{Int64,2},Array{Int64,1}})
    no_states = stationary_distributions(mc)[1] |> length
    for i in 1:no_states
        line = simulate(mc, 10, init = i)
        i == 1 ? display(plot(1:no_steps, line, label = string(i), lw = 2)) : display(plot!(line, label = string(i), lw = 2))
    end
end

plot_markov(10, mc)

# Mateusz raczej powinienes definiowac funkcje jako function <name>(params)
# wtedy można dodawać metody a w takim zapisie jak niżej nie

# Wykorzystamy pakiet distributions, by moc losowac z podstawowych
# rozkladow prawdopodobienstwa

# nawiasy kwadratowe przy wprowadzaniu danych - array, tuple - okragle
# poniewaz nie jest to az tak intuicyjne pisze to tak, by w obu przypadkach
# julia cos wyplula (jeśli tylko to, co zada uzytkownik ma sens)

# generowanie losowej gry, okreslone przez losowy rozklad i liczbe akcji
# konwersja tuple w array i ponownie array w tuple, gdyz reshape nie ma
# metody dla array

game = function(dist, actions)

reshape(rand(dist, prod(actions)*length(actions)),
Tuple(vcat(collect(actions), length(actions))))

end

gam1 = game(Normal(0, 1), (2, 3))
gam1

# okreslanie wyplat przy danych profilach strategii

strat1 = [1/2, 1/2]
strat2 = [1/2, 1/4, 1/2]

getpayoff = function(game, strat1, strat2)

temp = game.*(collect(strat1).*transpose(collect(strat2)))

# aby nie definiowac stale liczby graczy

temp2 = 1
for i = 2:(ndims(game) - 1)
temp2 = vcat(temp2, i)
end

sum(temp, dims = temp2)

end

pay = getpayoff(gam1, strat1, strat2)
pay

# payoffs jako funkcja

# wizualizacja dla 2 graczy - niestety nie widze jakiegos zgrabnego rozwiazania
# innego niz zwykle wyliczenie tego zbioru - kazda akcja moze byc w strategii mieszanej powiedzmy do 1/1000 jej czesci,
# obliczamy wszystkie mozliwe payoffs i wizualizujemy
