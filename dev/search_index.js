var documenterSearchIndex = {"docs":
[{"location":"reference/#Reference-1","page":"Reference","title":"Reference","text":"","category":"section"},{"location":"reference/#","page":"Reference","title":"Reference","text":"CurrentModule = Nash\r\nDocTestSetup = quote\r\n    using Nash\r\nend","category":"page"},{"location":"reference/#Utilities-1","page":"Reference","title":"Utilities","text":"","category":"section"},{"location":"reference/#","page":"Reference","title":"Reference","text":"outer\r\nplot_br\r\ncart_prod_simplices","category":"page"},{"location":"reference/#Nash.outer","page":"Reference","title":"Nash.outer","text":"outer(vecs::Array{Array{T,1},1}) where T<:Real\n\nTakes vector of vectors and return outer product tensor\n\nInput parameters\n\nvecs::Array{Array{T,1},1} - array of vectors to use in outer product\n\n\n\n\n\nouter(vecs::Array{Array{SymPy.Sym,1},1})\n\nTakes vector of symbolic vectors and return outer product tensor\n\nInput parameters\n\nvecs::Array{Array{SymPy.Sym,1},1} - array of symbolic vectors to use in outer product\n\n\n\n\n\n","category":"function"},{"location":"reference/#Nash.plot_br","page":"Reference","title":"Nash.plot_br","text":"plot_br(br::CDDLib.Polyhedron{T}) where T<:Real\n\nPlots best reply in the form of simplex (3d and above)\n\nInput parameters\n\nbr::CDDLib.Polyhedron{T}) - bestreply function (with returnval=\"chull\") output\n\n\n\n\n\n","category":"function"},{"location":"reference/#Games-1","page":"Reference","title":"Games","text":"","category":"section"},{"location":"reference/#","page":"Reference","title":"Reference","text":"generate_game\r\nrandom_2players_game\r\nrandom_nplayers_game","category":"page"},{"location":"reference/#Nash.generate_game","page":"Reference","title":"Nash.generate_game","text":"generate_game(payoffm...)\n\nReturns given payoff matrices for given number of players with given number of actions\n\nInput parameters\n\npayoffm - payoff matrices\n\n\n\n\n\n","category":"function"},{"location":"reference/#Nash.random_2players_game","page":"Reference","title":"Nash.random_2players_game","text":"random2playersgame(dist::Distributions.Sampleable,p1size::Int,p2size::Int)\n\nReturns random payoff matrices for 2 players with given number of actions\n\nInput parameters\n\ndist::Distributions.Sampleable - distribution from which payoffs are sampled\np1_size::Int - number of actions of first player\np2_size::Int - number of actions of second player\n\n\n\n\n\n","category":"function"},{"location":"reference/#Nash.random_nplayers_game","page":"Reference","title":"Nash.random_nplayers_game","text":"randomnplayersgame(dist::Distributions.Sampleable, size::Union{Array{Int,1},Tuple})\n\nReturns random payoffs for n players with given number of actions\n\nInput parameters\n\ndist::Distributions.Sampleable - distribution from which payoffs are sampled\nsize::Union{Array{Int,1},Tuple} - vector or tuple of number of players' actions\n\n\n\n\n\n","category":"function"},{"location":"reference/#Equilibria-and-best-responses-1","page":"Reference","title":"Equilibria and best responses","text":"","category":"section"},{"location":"reference/#","page":"Reference","title":"Reference","text":"get_payoff\r\nbest_reply\r\nis_nash_q\r\niterate_best_reply\r\nvFunction","category":"page"},{"location":"reference/#Nash.get_payoff","page":"Reference","title":"Nash.get_payoff","text":"get_payoff(game::Dict{String,<:AbstractArray}, s::Vector{Vector{T}}) where T<:Real\n\nProduces payoff profile for given game and actions probabilities array\n\nInput parameters\n\ngame::Dict{String,<:AbstractArray} - array of vectors to use in outer product\ns::Vector{Vector{T}} - collection of actions probabilities for each player in a game\n\n\n\n\n\nget_payoff(game::Dict{String,<:AbstractArray}, s::Vector{Vector{SymPy.Sym}})\n\nProduces payoff profile for given game and actions probabilities symbolic array\n\nInput parameters\n\ngame::Dict{String,<:AbstractArray} - array of vectors to use in outer product\ns::Vector{Vector{SymPy.Sym}} - collection of actions probabilities for each player in a game\n\n\n\n\n\n","category":"function"},{"location":"reference/#Nash.best_reply","page":"Reference","title":"Nash.best_reply","text":"best_reply(game::Dict{String,<:Array}, s::Vector{Vector{T}} where T<:Real,\nk::Int, epsil::F=0.0 ;return_val::String = \"array\") where F<:Real\n\nReturns best reply of given player to actions of his counterparts (defined by strategy profile) in the form of array or convex hull\n\nInput parameters\n\ngame::Dict{String,<:Array} - dictionary of players and their payoff matrices\ns::Vector{Vector{T}} where T<:Real - collection of actions probabilities for each player in a game\nk::Int - player for which the best reply is returned\nepsil::F = 0.0 - probability of error (if the answer is disturbed)\nreturn_val::String = \"array\" - type of returned value (\"array\" or \"chull\")\n\n\n\n\n\n","category":"function"},{"location":"reference/#Nash.is_nash_q","page":"Reference","title":"Nash.is_nash_q","text":"is_nash_q(game::Dict{String,<:Array}, s::Vector{Vector{T}}) where T<:Real\n\nReturns a dictionary of logical vectors indicating whether given profile is Nash equilibrium.\n\nInput parameters\n\ngame::Dict{String,<:Array} - dictionary of players and their payoff matrices\ns::Vector{Vector{T}}) - collection of actions probabilities for each player\n\n\n\n\n\n","category":"function"},{"location":"reference/#Nash.iterate_best_reply","page":"Reference","title":"Nash.iterate_best_reply","text":"iterate_best_reply(game::Dict{String,<:Array},\n        s::Vector{Vector{T}} where T<:Real,\n        epsil::F = 0.0, it_num::Int = 10)  where F<:Real\n\nReturns an array of arrays representing each players' game strategies (action probabilities) history in every iteration\n\nInput parameters\n\ngame::Dict{String,<:Array} - dictionary of players and their payoff matrices\ns::Vector{Vector{T}} where T<:Real - collection of actions probabilities for each player\nepsil::F = 0.0 - probability of error (if the answer is disturbed)\nit_num::Int = 10 - an integer specifying how many iterations should be repeated\n\n\n\n\n\n","category":"function"},{"location":"reference/#Markov-chains-1","page":"Reference","title":"Markov chains","text":"","category":"section"},{"location":"reference/#","page":"Reference","title":"Reference","text":"game2markov\r\nplot_markov","category":"page"},{"location":"reference/#Nash.game2markov","page":"Reference","title":"Nash.game2markov","text":"game2markov(game::Dict{String,<:Array}, s::Vector{Vector{T}}) where T<:Real\n\nReturns Markov chain of a given game and given vector of action probabilities\n\nInput parameters\n\ngame::Dict{String,<:Array} - dictionary of players and their payoff matrices\ns::Vector{Vector{T}} - collection of actions probabilities for each player\n\n\n\n\n\n","category":"function"},{"location":"reference/#Nash.plot_markov","page":"Reference","title":"Nash.plot_markov","text":"plot_markov(no_steps::Int, mc::MarkovChain{Int,Array{Int,2},Array{Int,1}})\n\nPlots a path of Markov chain simulation of a given time length and all initial values\n\nInput parameters\n\nno_steps::Int - scalar of time length (number of iterations)\nmc::MarkovChain{Int,Array{Int,2},Array{Int,1}} - Markov chain of a game (game2markov output function)\n\n\n\n\n\n","category":"function"},{"location":"reference/#Symmetric-games-1","page":"Reference","title":"Symmetric games","text":"","category":"section"},{"location":"reference/#","page":"Reference","title":"Reference","text":"random_symmetric_2players_game\r\nfind_symmetric_nash_equilibrium_2players_game\r\ncreate_symmetries_graph\r\ncheck_equality_condition\r\nfind_all_equalities","category":"page"},{"location":"reference/#Nash.random_symmetric_2players_game","page":"Reference","title":"Nash.random_symmetric_2players_game","text":"random_symmetric_2players_game(dist::Distributions.Sampleable,p1_size::Int,p2_size::Int)\n\nReturns random symmetric payoff matrices for 2 players with given number of actions\n\nInput parameters\n\ndist::Distributions.Sampleable - distribution from which payoffs are sampled\np_size::Int - number of actions of a player\n\n\n\n\n\n","category":"function"},{"location":"reference/#Nash.find_symmetric_nash_equilibrium_2players_game","page":"Reference","title":"Nash.find_symmetric_nash_equilibrium_2players_game","text":"find_symmetric_nash_equilibrium_2players_game(game::Dict{String,<:AbstractArray}, s::Array{SymPy.Sym,1})\n\nFinds necessary values to find symmetric Nash equilibrium\n\nInput parameters\n\ngame::Dict{String,<:AbstractArray} - dictionary of players and their payoff matrices\ns::Array{SymPy.Sym,1} - collection of actions probabilities\n\n\n\n\n\n","category":"function"},{"location":"reference/#Nash.create_symmetries_graph","page":"Reference","title":"Nash.create_symmetries_graph","text":"create_symmetries_graph(actions_no_vector::Array{Int64})\n\nReturn graph of needed symmetries in the game\n\nInput parameters\n\nactions_no_vector::Array{Int64} - array of number of actions of consecutive players\n\n\n\n\n\n","category":"function"},{"location":"reference/#Nash.check_equality_condition","page":"Reference","title":"Nash.check_equality_condition","text":"check_equality_condition(g::SymmetriesGraph, payout_1, payout_2)\n\nChecks if there needs to be an equality between two payouts\n\nInput parameters\n\ng::SymmetriesGraph - symmetries graph\npayout_1 - first payout\npayout_2 - second payout\n\n\n\n\n\n","category":"function"},{"location":"reference/#Nash.find_all_equalities","page":"Reference","title":"Nash.find_all_equalities","text":"find_all_equalities(g::SymmetriesGraph)\n\nFinds all payout tuples, that need to be equal\n\nInput parameters\n\ng::SymmetriesGraph - symmetries graph\n\n\n\n\n\n","category":"function"},{"location":"#Nash.jl-1","page":"Nash.jl","title":"Nash.jl","text":"","category":"section"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"Nash.jl is a package providing selected functionalities from game theory field. The package focuses mainly on providing basic functions to define games and finding Nash equilibria.It was created as part of academic game theory course.","category":"page"},{"location":"#Tutorial-1","page":"Nash.jl","title":"Tutorial","text":"","category":"section"},{"location":"#Games-definition-1","page":"Nash.jl","title":"Games definition","text":"","category":"section"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"Nash.jl defines game in package specific format. Currently there are 3 functions supporting game definition:","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"generate_game - requires payoffs tensor as an argument to create game object with known payoffs values\nrandom_2players_game - creates game object for 2 players with payoffs sampled randomly from provided distribution (from Distributions.jl package)\nrandom_nplayers_game - creates game object for specified number of players with payoffs sampled randomly from provided distribution (from Distributions.jl package)","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"For 2-players game with payoffs for first player as follows:","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"1 if player1 plays first action and player2 plays first action\n2 if player1 plays first action and player2 plays second action\n2.5 if player1 plays second action and player2 plays first action\n3 if player1 plays second action and player2 plays second action","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"following function call may be used (payoffs for the second player analogous):","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"generate_game([1 2; 2.5 3],[2 3;3.5 4])\r\n> Dict{String,Array{Float64,2}} with 2 entries:\r\n>  \"player2\" => [2.0 3.0; 3.5 4.0]\r\n>  \"player1\" => [1.0 2.0; 2.5 3.0]","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"Generation of random 2-players game with payoffs drawn from normal distribution (mean - 0, std - 2), 2 actions for player1 and 3 actions for player2","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"using Distributions\r\nrandom_2players_game(Normal(0,2),2,3)\r\n> Dict{String,Array{Float64,2}} with 2 entries:\r\n>  \"player2\" => [2.80393 -1.9793 -1.52571; -1.50642 -0.0574021 1.0391]\r\n>  \"player1\" => [2.2755 -0.224079 0.0240092; 0.466656 -2.85657 2.40831]","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"Generation of random 3-players game with payoffs drawn from exponential distribution (mean - 3) and 2 actions for each player","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"using Distributions\r\nusing Random\r\nRandom.seed!(42);\r\n\r\ngame = random_nplayers_game(Exponential(2),[2,2,2])\r\n> Dict{String,Array{Float64,3}} with 3 entries:\r\n>  \"player3\" => [2.22898 0.133327; 2.9479 0.792779]…\r\n>  \"player2\" => [7.32142 3.5243; 0.959199 0.619313]…\r\n>  \"player1\" => [1.61285 0.307649; 1.20677 0.30259]…","category":"page"},{"location":"#Payoff-profile-and-best-reply-1","page":"Nash.jl","title":"Payoff profile and best reply","text":"","category":"section"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"To get payoff profile for game with mixed strategies use get_payoff function. Payoffs for 3-players game defined in Games definition section with 0.5 probability for all players actions:","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"get_payoff(game,[[0.5,0.5],[0.5,0.5],[0.5,0.5]])\r\n> Dict{String,Float64} with 3 entries:\r\n>  \"player3\" => 1.57951\r\n>  \"player2\" => 2.58725\r\n>  \"player1\" => 1.25779","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"best_reply function returns array or convex hull of best replies for k-th player in game with mixed strategies.","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"Best response for second player:","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"best_reply(game, [[0.5,0.5],[0.5,0.5],[0.5,0.5]],2)\r\n> 1×2 Array{Int64,2}:\r\n> 1  0","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"To use convex hull from Polyhedra.jl package specify return_val=\"chull\". May take considerable time to finish.","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"best_reply(game, [[0.5,0.5],[0.5,0.5],[0.5,0.5]],2, return_val=\"chull\")","category":"page"},{"location":"#Nash-equlibria-1","page":"Nash.jl","title":"Nash equlibria","text":"","category":"section"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"Given strategies profile for a game is_nash_q checks if the profile is a Nash equilibrium.","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"is_nash_q(game, [[0.5,0.5],[0.5,0.5],[0.5,0.5]])","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"To iteratively find best profile for each player use iterate_best_reply function. Additional disturbance parameter and number of iterations may be specified.","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"iterate_best_reply(game, [[0.5,0.5],[0.5,0.5],[0.5,0.5]],0.,20)","category":"page"},{"location":"#Symmetric-games-1","page":"Nash.jl","title":"Symmetric games","text":"","category":"section"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"random_symmetric_2players_game generate random 2-players game with payoffs drawn from specified distribution","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"using Random\r\nRandom.seed!(42);\r\nsymgame = random_symmetric_2players_game(Normal(1,2),2)\r\n> Dict{String,AbstractArray{Float64,2}} with 2 entries:\r\n>  \"player2\" => [1.61285 1.20677; 0.307649 0.30259]\r\n>  \"player1\" => [1.61285 0.307649; 1.20677 0.30259]","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"To find Nash equilibria for symmetric game:","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"find_symmetric_nash_equilibrium_2players_game(symgame, [SymPy.Sym(0.5),SymPy.Sym(0.5)])","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"To produce symmetries graph use:","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"g = create_symmetries_graph([2,2])\r\n> [ Info: Created payout tensor: [((1, 1), 1), ((1, 1), 2), ((1, 2), 1), ((1, 2), 2), ((2, 1), 1), ((2, 1), 2), ((2, 2), 1), ((2, 2), 2)]\r\n> Nash.SymmetriesGraph({8, 4} undirected simple Int64 graph, Dict(((2, 2), 2) => 8,((1, 1), 1) => 1,((1, 1), 2) => 2,((2, 1), 2) => 6,((1, 2), 2) => 4,((1, 2), 1) => 3,((2, 1), 1) => 5,((2, 2), 1) => 7), Dict(7 => ((2, 2), 1),4 => ((1, 2), 2),2 => ((1, 1), 2),3 => ((1, 2), 1),8 => ((2, 2), 2),5 => ((2, 1), 1),6 => ((2, 1), 2),1 => ((1, 1), 1)))","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"To check equality of two payouts in the graph:","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"check_equality_condition(g,((1, 1), 1),((2, 1), 1))\r\n> false\r\n\r\ncheck_equality_condition(g,((1, 1), 1),((1, 1), 2))\r\n> true","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"To find all nodes with equal payout:","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"find_all_equalities(g)\r\n> 4-element Array{Tuple{Tuple{Tuple{Int64,Int64},Int64},Tuple{Tuple{Int64,Int64},Int64}},1}:\r\n> (((1, 1), 1), ((1, 1), 2))\r\n> (((1, 2), 2), ((2, 1), 1))\r\n> (((2, 2), 1), ((2, 2), 2))\r\n> (((1, 2), 1), ((2, 1), 2))","category":"page"},{"location":"#Markov-chain-analysis-1","page":"Nash.jl","title":"Markov chain analysis","text":"","category":"section"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"Game may be represented as Markov chain using game2markov function (2-player games).","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"using Random\r\nRandom.seed!(42);\r\ngame = random_2players_game(Normal(0,1),2,2)\r\nmc = game2markov(game,[[0.5,0.5],[0.5,0.5]])\r\n> Discrete Markov Chain stochastic matrix of type Array{Int64,2}:\r\n> [0 1 0 0; 0 0 0 1; 1 0 0 0; 0 0 1 0]","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"To visualize results for 5 steps in produced Markov chain run:","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"plot_markov(5,mc)","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"(Image: )","category":"page"},{"location":"#Advanced-Nash-equlibria-optimization-1","page":"Nash.jl","title":"Advanced Nash equlibria optimization","text":"","category":"section"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"vFunction(game,[[0.5,0.5],[0.5,0.5]])\r\n> 0.421938354571314","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"It is not possible to fully implement finding NE through optimization without heavily modifing Julia optimization packages","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"The most promising at the time being is Manopt.jl (Manifold Optimization) https://github.com/JuliaManifolds/Manopt.jl using certain data types from Manifolds.jl (https://github.com/JuliaManifolds/Manifolds.jl).","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"However, at the time being (06.09.2020) not every manifold type from Manifolds.jl is supported/imported to that library https://github.com/JuliaManifolds/Manopt.jl/blob/master/src/Manopt.jl","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"especially not Probability Simplex","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"https://github.com/JuliaManifolds/Manifolds.jl/blob/master/src/manifolds/ProbabilitySimplex.jl crucial to finding NE through vFunction optimization","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"Other packages are far less advanced - JuMP https://jump.dev/JuMP.jl/v0.21.1/installation/index.html is a Julia frontend for various solvers and solver syntax is the best for that library.","category":"page"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"Optim.jl at the time being supports only very simple manifold constraints and only for first-order algorithms https://julianlsolvers.github.io/Optim.jl/stable/#algo/manifolds/","category":"page"}]
}
