module Nash

#packages
using Distributions
using LinearAlgebra
using CDDLib
using Polyhedra
using MeshCat

#functions
export generate_game, random_2players_game, random_nplayers_game, outer,
get_payoff, best_reply, is_nash_q, plot_br

export game, getpayoff

#files
include("game_theory.jl")

end
