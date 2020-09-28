
"""
    create_replicator_eqs(game::Dict{String,<:AbstractArray}, s::Array{SymPy.Sym,1})
    
Creates differential equations for replicator

**Input parameters**
* `game::Dict{String,<:AbstractArray}` - dictionary of players and their payoff matrices
* `s::Array{SymPy.Sym,1}` - collection of symbolic actions probabilities
"""
function create_replicator_eqs(game::Dict{String,<:AbstractArray},
               s::Array{SymPy.Sym,1})
    n = size(game["player1"])[1]
    id_m = Matrix(1I, n, n)
    res = []
    for i in 1:n
        append!(res, sympy.simplify(s[i]*(get_payoff(game, [map(x->sympify(x), id_m[i, :]), s])["player1"] - get_payoff(game, [s, s])["player1"])))
    end
    return res
end
