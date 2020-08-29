module Nash

#packages
using Base.Threads
using Distributions
using LightGraphs
using LinearAlgebra
using CDDLib
using Polyhedra
using MeshCat
using Combinatorics
using IterTools
using QuantEcon
using Plots
using Roots
using SymPy

#utilities.jl
export outer, plot_br
#games.jl
export generate_game, random_2players_game, random_nplayers_game
#equilibria.jl
export get_payoff, best_reply, is_nash_q, iterate_best_reply
#markov.jl
export game2markov, plot_markov
#symmetric.jl
export random_symmetric_2players_game, find_symmetric_nash_equilibrium_2players_game, create_symmetries_graph, check_equality_condition, find_all_equalities
#NEOptim.jl

#files
include("utilities.jl")
include("games.jl")
include("equilibria.jl")
include("markov.jl")
include("symmetric.jl")
include("NEOptim.jl")

end
