using Test
using Nash
using Distributions

@testset "games" begin

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
end