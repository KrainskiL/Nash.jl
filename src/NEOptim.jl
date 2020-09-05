###############################################
# Finding Nash Equlibria through optimization #
###############################################

"""
vFunction(game::Dict{String,<:AbstractArray},
                s::Vector{Vector{T}}) where T<:Real

Computes numerically for a given game and a given profile V - function crucial
to implement finding NE through optimization, if it equal to 0 - given
profile is a Nash Equilibrium, if greater - not

**Input Parameters**
* `game::Dict{String,<:AbstractArray}` - dictionary containing a game
* `s::Vector{Vector{T}}` - strategy profile for which we want to compute V - function
"""

function vFunction(game::Dict{String,<:AbstractArray},
                s::Vector{Vector{T}}) where T<:Real

    if !all(@. round(sum(s), digits = 2) == 1)
        error("Provided vectors are not a strategy profile")
    end

v = 0.0

for i in 1:length(s)
    PlayerActions = Matrix(1I, length(s[i]), length(s[i]))
    for j in 1:length(s[i])
        temp = deepcopy(s)
        temp[i] = PlayerActions[j,:]
        for k in 1:length(s)
        v = v + max(0, get_payoff(game, temp)[string("player",k)] - get_payoff(game, s)[string("player",k)])^2
end
    end
end

return v

end

"""
cart_prod_simplices(s::Vector{Vector{T}}) where T<:Real

Creates cartesian product of probability simplices for a given vector of vectors (especially - for a strategy profile)

from Manifold.jl
function(ProbabilitySimplex(n)) creates n-probability simplex
× - creates product

**Input Parameters**
* `s::Vector{Vector{T}}` - vector of vectors for which we create cartesian product of probability simplices
"""

function cart_prod_simplices(s::Vector{Vector{T}}) where T<:Real

vec = ProbabilitySimplex(length(s[1]))

for i in 2:length(s)
vec = vec × ProbabilitySimplex(length(s[i]))
end

return vec

end
