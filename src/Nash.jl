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

#functions
export generate_game, random_2players_game, random_nplayers_game, outer,
get_payoff, best_reply, is_nash_q, plot_br, iterate_best_reply, game2markov,
plot_markov

export game, getpayoff

#files
include("game_theory.jl")

end
