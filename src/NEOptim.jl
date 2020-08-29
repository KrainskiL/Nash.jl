"""
Work in progress
"""

using Nash

###############################################
# Finding Nash Equlibria through optimization #
###############################################

"""
It is not possible to fully implement finding Nash Equilibria through
optimization - the main Julia package with optimization algorithms (Optim.jl)
https://julianlsolvers.github.io/Optim.jl/stable/ - at the time being
supports only box-constrained and very simple manifold-constrained
optimization, therefore it is not possible to set cartesian product of simplexes
as a bound, I have not found any optimization package written in pure Julia
which supoorts it, even in ScyPy linear and non-linear constraints are
available only in certain optimization methods (COBYLA, SLSQP and trust-constr)
- https://docs.scipy.org/doc/scipy/reference/generated/scipy.optimize.minimize.html#scipy.optimize.minimize
"""

"""
vFunctionnum

**Input Parameters**
game, payoffs,
"""



"""
vFunctionsym

**Input Parameters**
"""
