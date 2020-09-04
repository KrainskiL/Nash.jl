##################
# Games creation #
##################

"""
generate_game(payoffm...)

Returns given payoff matrices for given number of players with given number of actions

**Input parameters**
* `payoffm` - payoff matrices
"""
function generate_game(payoffm...)
    #!all(@. collect(payoffm) isa Array{<: Real}) && return @error "All arguments have to be arrays"
    !all(y->y==size.(payoffm)[1], size.(payoffm)) && return @error "All arrays should have same dimension"
    !all(size.(payoffm) .|> length .== length(payoffm)) && return @error "Dimensions of payoff matrices should equal to number of players (input arguments)"
    return Dict("player"*string(i)=>collect(payoffm)[i] for i in 1:length(payoffm))
end

"""
random_2players_game(dist::Distributions.Sampleable,p1_size::Int,p2_size::Int)

Returns random payoff matrices for 2 players with given number of actions

**Input parameters**
* `dist::Distributions.Sampleable` - distribution from which payoffs are sampled
* `p1_size::Int` - number of actions of first player
* `p2_size::Int` - number of actions of second player
"""
function random_2players_game(dist::Distributions.Sampleable,
                        p1_size::Int,
                        p2_size::Int)
    return Dict("player"*string(i)=>rand(dist, p1_size, p2_size) for i in 1:2)
end

"""
random_nplayers_game(dist::Distributions.Sampleable, size::Union{Array{Int,1},Tuple})

Returns random payoffs for n players with given number of actions

**Input parameters**
* `dist::Distributions.Sampleable` - distribution from which payoffs are sampled
* `size::Union{Array{Int,1},Tuple}` - vector or tuple of number of players' actions
"""
function random_nplayers_game(dist::Distributions.Sampleable,
                        size::Union{Array{Int,1},Tuple})
    return Dict("player"*string(i)=>rand(dist, size...) for i in 1:length(size))
end
