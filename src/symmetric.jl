struct SymmetriesGraph
    graph::SimpleGraph{Int64}
    node_lookup
    reverse_node_lookup
end


"""
    random_symmetric_2players_game(dist::Distributions.Sampleable,p1_size::Int,p2_size::Int)

Returns random symmetric payoff matrices for 2 players with given number of actions

**Input parameters**
* `dist::Distributions.Sampleable` - distribution from which payoffs are sampled
* `p_size::Int` - number of actions of a player
"""
function random_symmetric_2players_game(dist::Distributions.Sampleable,
                               p_size::Int)
    random_data = rand(dist, p_size, p_size)
    data = [random_data, transpose(random_data)]
    return Dict("player"*string(i)=>data[i] for i in 1:2)
end


"""
    find_symmetric_nash_equilibrium_2players_game(game::Dict{String,<:AbstractArray}, s::Array{SymPy.Sym,1})

Finds necessary values to find symmetric Nash equilibrium

**Input parameters**
* `game::Dict{String,<:AbstractArray}` - dictionary of players and their payoff matrices
* `s::Array{SymPy.Sym,1}` - collection of actions probabilities
"""
function find_symmetric_nash_equilibrium_2players_game(game::Dict{String,<:AbstractArray},
               s::Array{SymPy.Sym,1})
    n = size(game["player1"])[1]
    id_m = Matrix(1I, n, n)
    res = 0
    for i in 1:n
        res = res + max(get_payoff(game, [map(x->sympify(x), id_m[i, :]), s])["player1"] - get_payoff(game, [s, s])["player1"], 0)^2
    end
    return find_zeros(res, 0, 1)
end


"""
    create_symmetries_graph(actions_no_vector::Array{Int64})

Return graph of needed symmetries in the game

**Input parameters**
* `actions_no_vector::Array{Int64}` - array of number of actions of consecutive players
"""
function create_symmetries_graph(actions_no_vector::Array{Int64})
    payout_tensor = [()]
    for k in actions_no_vector
        payout_tensor = collect(Iterators.flatten([[(j...,i) for i in 1:k] for j in payout_tensor]))
    end
    payout_tensor = collect(Iterators.flatten([[(j,i) for i in 1:length(actions_no_vector)] for j in payout_tensor]))
    @info "Created payout tensor: $(payout_tensor)"

    p = permutations(collect(1:length(actions_no_vector)))
    equalities = unique(collect(Iterators.flatten([[(b, (b[1][i], i[b[2]])) for i in p] for b in payout_tensor])))
    equalities = filter(x -> x[1]!=x[2], equalities)
    G₁ = Graph(length(payout_tensor))
    node_lookup = Dict(payout_tensor[i] => i for i in 1:length(payout_tensor))
    for i in equalities
        add_edge!(G₁, node_lookup[i[1]], node_lookup[i[2]])
    end
    return SymmetriesGraph(G₁, node_lookup, Dict(value => key for (key, value) in node_lookup))
end


"""
    check_equality_condition(g::SymmetriesGraph, payout_1, payout_2)

Checks if there needs to be an equality between two payouts

**Input parameters**
* `g::SymmetriesGraph` - symmetries graph
* `payout_1` - first payout
* `payout_2` - second payout
"""
function check_equality_condition(g::SymmetriesGraph, payout_1, payout_2)
    return has_path(g.graph, g.node_lookup[payout_1], g.node_lookup[payout_2])
end


"""
    find_all_equalities(g::SymmetriesGraph)

Finds all payout tuples, that need to be equal

**Input parameters**
* `g::SymmetriesGraph` - symmetries graph
"""
function find_all_equalities(g::SymmetriesGraph)
    tmp = Dict{Int64,Vector{Tuple{Int64, Int64}}}()
    Threads.@threads for i in vertices(g.graph)
        tmp[i] = collect(unique(filter(x->x[2]>x[1],map(x->(dst(x),i), edges(dfs_tree(g.graph, i))))))
    end
    return map(x -> (g.reverse_node_lookup[x[1]], g.reverse_node_lookup[x[2]]), collect(Iterators.flatten(values(tmp))))
end
