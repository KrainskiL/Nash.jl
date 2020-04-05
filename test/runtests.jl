using Test
using Nash
using Distributions
using Polyhedra
using CDDLib
using LinearAlgebra

@testset "games" begin

ggame = generate_game([1 0; 0 1], [1 0; 0 1])
@test typeof(ggame) == Dict{String,Array{Int64,2}}
@test typeof(ggame["player1"]) == Array{Int64,2}

p2game = random_2players_game(Normal(0,2),2,3)
@test typeof(p2game["player1"]) == Array{Float64,2}
@test typeof(p2game["player2"]) == Array{Float64,2}

npgame = random_nplayers_game(Binomial(5,0.5),[2,3,3]);
@test typeof(npgame["player1"]) == Array{Int64,3}

s = [[0.5,0.5],[0.75,0.25]]
out = outer(s)
@test typeof(out) == Array{Float64,2}
@test out[1][1] == s[1][1]*s[2][1]

game = random_nplayers_game(Binomial(5,0.5),[2,2]);
payoffs = get_payoff(game,s)
@test typeof(payoffs) == Dict{String,Float64}
@test payoffs["player2"] == s[1]'*game["player2"]*s[2]

bp1 = best_reply(generate_game([1 0; 0 1], [1 0; 0 1]), [[1, 0], [1, 0]], 1)
bp2 = best_reply(generate_game([1 0; 0 1], [1 0; 0 1]), [[1, 0], [1, 0]], 2)
bp1p = best_reply(generate_game([1 0; 0 1], [1 0; 0 1]), [[1, 0], [1, 0]], 1, 1/5)
bpch = best_reply(generate_game(Matrix(I,3,3), Matrix(I,3,3)), [[1/2,1/2,0],[1/3,1/3,1/3]], 1, return_val = "chull")
@test bp1 == bp2
@test bp1 == [1 0]
@test bp2 isa Array{<:Real,2}
@test bp1p isa Array{<:Real,2}
@test bpch isa CDDLib.Polyhedron{<:Real}

nashq = is_nash_q(generate_game([1 0 ; 0 1], [1 0; 0 1]), [[1, 0], [1, 0]])
@test typeof(nashq) == Dict{String,Bool}
@test nashq["Nash"] == true

game_hist = iterate_best_reply(game, s, 0.5, 7)
@test length(game_hist) == 8
@test game_hist isa Array{Any,1} #TODO in future not Any type
@test game_hist[1] isa Array{Array{Float64,1},1}
end
