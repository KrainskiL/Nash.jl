module Nash

#packages
using Distributions
using LinearAlgebra
using CDDLib
using Polyhedra
using MeshCat
using Combinatorics
using IterTools
using QuantEcon
using Plots

#utilities.jl
export outer, plot_br
#games.jl
export generate_game, random_2players_game, random_nplayers_game
#equilibria.jl
export get_payoff, best_reply, is_nash_q, iterate_best_reply
#markov.jl
export game2markov, plot_markov

# export game, getpayoff

#files
include("utilities.jl")
include("games.jl")
include("equilibria.jl")
include("markov.jl")

end
