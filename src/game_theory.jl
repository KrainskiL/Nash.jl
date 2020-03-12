# Wykorzystamy pakiet distributions, by moc losowac z podstawowych
# rozkladow prawdopodobienstwa

using Distributions

# nawiasy kwadratowe przy wprowadzaniu danych - array, tuple - okragle
# poniewaz nie jest to az tak intuicyjne pisze to tak, by w obu przypadkach
# julia cos wyplula (jeśli tylko to, co zada uzytkownik ma sens)

# generowanie losowej gry, okreslone przez losowy rozklad i liczbe akcji
# konwersja tuple w array i ponownie array w tuple, gdyz reshape nie ma
# metody dla array

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
* `s` - vector of actions probabilities vector
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
