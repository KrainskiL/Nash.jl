module Nash

#packages
using Distributions

#functions
export random_2players_game, random_nplayers_game, outer, get_payoff
export game, getpayoff

#files
include("game_theory.jl")

end
