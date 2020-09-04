###############################################
# Finding Nash Equlibria through optimization #
###############################################

"""
It is not possible to fully implement finding Nash Equilibria through
optimization in pure Julia - the main Julia package with optimization algorithms
(Optim.jl) https://julianlsolvers.github.io/Optim.jl/stable/ - at the time being
supports only box-constrained and very simple manifold-constrained
optimization (only first-order methods), therefore it is not possible to set
cartesian product of simplexes as an optimization bound, I have not found any
optimization package written in pure Julia which supoorts it, even in one of the
most popular Python packages - ScyPy linear and non-linear constraints are
available only in certain optimization methods (COBYLA, SLSQP and trust-constr)
- https://docs.scipy.org/doc/scipy/reference/generated/scipy.optimize.minimize.html#scipy.optimize.minimize
"""

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

v = 0

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
