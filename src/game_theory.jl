# Wykorzystamy pakiet distributions, by moc losowac z podstawowych
# rozkladow prawdopodobienstwa

using Distributions
using LinearAlgebra
using CDDLib
using Polyhedra

# nawiasy kwadratowe przy wprowadzaniu danych - array, tuple - okragle
# poniewaz nie jest to az tak intuicyjne pisze to tak, by w obu przypadkach
# julia cos wyplula (jeśli tylko to, co zada uzytkownik ma sens)

# generowanie losowej gry, okreslone przez losowy rozklad i liczbe akcji
# konwersja tuple w array i ponownie array w tuple, gdyz reshape nie ma
# metody dla array

"""
`generate_game` return given payoff matrices for given number
of players with given number of actions

**Input parameters**
* `payoffm` - payoff matrix
"""
function generate_game(payoffm...)
    !all(@. collect(payoffm) isa Array{<: Real}) && return @error "All arguments have to be arrays"
    !all(y->y==size.(payoffm)[1], size.(payoffm)) && return @error "All arrays should have same dimension"
    Dict("player"*string(i)=>collect(payoffm)[i] for i in 1:length(payoffm))
    #note: collect is costly; maybe any other ideas?
end

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
    if !all(sum.(s).==1)
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
* `return_val` - type of returned value ("array" or "chull")
"""
function best_reply(game::Dict{String,<:Array}, s::Vector{Vector{T}}, k::Int,
    ;return_val::String="array") where T<:Real
    payoffs=[] #Vector{<:Real} albo z where nie dziala - no idea why
    # musi byc any lecz nie jest to optymalne gdyz taki vector wolniej sie przeszukuje
    for i in 1:length(s[k])
        s[k] = zeros(length(s[k]))
        s[k][i] = 1
        push!(payoffs, get_payoff(game, s)["player"*string(k)])
    end
    pos = (payoffs .== maximum(payoffs))
    # a fragment which s specific for two players
    # extending to n players will require some generalization with pasting content
    # and evaluation (e.g.) [string(pos)*rep(":", n-1)] which I am not aware of in Julia
    # at the moment / I will mark as TODO
    # furthermore the xamples we made @ class were also for players
    eyemat = Matrix(I, size(game["player"*string(k)])[1], size(game["player"*string(k)])[2])
    if k == 1 val2ret = eyemat[pos, :]
    elseif k == 2 val2ret = transpose(eyemat[:, pos])
    end
    if return_val == "chull"
        polyh = polyhedron(vrep(val2ret), CDDLib.Library())
        return convexhull(polyh,polyh)
        # one may plot this unless its in 2d
        # using Plots; plot(pch, color="green", alpha=0.1)
    else return val2ret
    end

end

a1 = best_reply(generate_game([1 0; 0 1], [1 0; 0 1]), [[1, 0], [1, 0]], 1, return_val = "chull")
a2 = best_reply(generate_game([1 0; 0 1], [1 0; 0 1]), [[1, 0], [1, 0]], 2, return_val = "chull")
a3 = best_reply(generate_game(Matrix(I,3,3), Matrix(I,3,3)), [[1/2,1/2,0],[1/3,1/3,1/3]], 1)
a4 = best_reply(generate_game(Matrix(I,3,3), Matrix(I,3,3)), [[1/2,1/2,0],[1/3,1/3,1/3]], 2, return_val = "chull")

"""
`is_nash_q` return logical vector indicating whether given profile is
Nash equilibrium.

**Input parameters**
* `game` - dictionary of players and their payoff matrices
* `s` - vector of actions probabilities
"""
function is_nash_q(game::Dict{String,<:Array}, s::Vector{Vector{T}}) where T<:Real
    nashqs=[]
    for k in 1:length(game)
        st = s[k]
        br = best_reply(game, s, k, return_val="chull")
        polyh = polyhedron(vrep([st]), CDDLib.Library())
        pint = intersect(br, polyh)
        push!(nashqs, npoints(pint) != 0)
    end
    all(nashqs) ? println("Nash equilibrium") : println("No Nash equilibrium")
    return nashqs #TODO return as Dict
end

# Mateusz raczej powinienes definiowac funkcje jako function <name>(params)
# wtedy można dodawać metody a w takim zapisie jak niżej nie
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
