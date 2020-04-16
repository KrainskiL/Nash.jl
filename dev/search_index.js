var documenterSearchIndex = {"docs":
[{"location":"reference/#Reference-1","page":"Reference","title":"Reference","text":"","category":"section"},{"location":"reference/#","page":"Reference","title":"Reference","text":"CurrentModule = Nash\r\nDocTestSetup = quote\r\n    using Nash\r\nend","category":"page"},{"location":"reference/#Utilities-1","page":"Reference","title":"Utilities","text":"","category":"section"},{"location":"reference/#","page":"Reference","title":"Reference","text":"outer\r\nplot_br","category":"page"},{"location":"reference/#Nash.outer","page":"Reference","title":"Nash.outer","text":"outer(vecs::Array{Array{T,1},1}) where T<:Real\n\nTakes vector of vectors and return outer product tensor\n\nInput parameters\n\nvecs::Array{Array{T,1},1} - array of vectors to use in outer product\n\n\n\n\n\n","category":"function"},{"location":"reference/#Nash.plot_br","page":"Reference","title":"Nash.plot_br","text":"plot_br(br::CDDLib.Polyhedron{T}) where T<:Real\n\nPlots best reply in the form of simplex (3d and above)\n\nInput parameters\n\nbr::CDDLib.Polyhedron{T}) - bestreply function (with returnval=\"chull\") output\n\n\n\n\n\n","category":"function"},{"location":"reference/#Games-1","page":"Reference","title":"Games","text":"","category":"section"},{"location":"reference/#","page":"Reference","title":"Reference","text":"generate_game\r\nrandom_2players_game\r\nrandom_nplayers_game","category":"page"},{"location":"reference/#Nash.generate_game","page":"Reference","title":"Nash.generate_game","text":"generate_game(payoffm...)\n\nReturns given payoff matrices for given number of players with given number of actions\n\nInput parameters\n\npayoffm - payoff matrices\n\n\n\n\n\n","category":"function"},{"location":"reference/#Nash.random_2players_game","page":"Reference","title":"Nash.random_2players_game","text":"random2playersgame(dist::Distributions.Sampleable,p1size::Int,p2size::Int)\n\nReturns random payoff matrices for 2 players with given number of actions\n\nInput parameters\n\ndist::Distributions.Sampleable - distribution from which payoffs are sampled\np1_size::Int - number of actions of first player\np2_size::Int - number of actions of second player\n\n\n\n\n\n","category":"function"},{"location":"reference/#Nash.random_nplayers_game","page":"Reference","title":"Nash.random_nplayers_game","text":"randomnplayersgame(dist::Distributions.Sampleable, size::Union{Array{Int,1},Tuple})\n\nReturns random payoffs for n players with given number of actions\n\nInput parameters\n\ndist::Distributions.Sampleable - distribution from which payoffs are sampled\nsize::Union{Array{Int,1},Tuple} - vector or tuple of number of players' actions\n\n\n\n\n\n","category":"function"},{"location":"reference/#Equilibria-and-best-responses-1","page":"Reference","title":"Equilibria and best responses","text":"","category":"section"},{"location":"reference/#","page":"Reference","title":"Reference","text":"get_payoff\r\nbest_reply\r\nis_nash_q\r\niterate_best_reply","category":"page"},{"location":"reference/#Nash.get_payoff","page":"Reference","title":"Nash.get_payoff","text":"get_payoff(game::Dict{String,<:AbstractArray}, s::Vector{Vector{T}}) where T<:Real\n\nProduces payoff profile for given game and actions probabilities array\n\nInput parameters\n\ngame::Dict{String,<:AbstractArray} - array of vectors to use in outer product\ns::Vector{Vector{T}} - collection of actions probabilities for each player in a game\n\n\n\n\n\n","category":"function"},{"location":"reference/#Nash.best_reply","page":"Reference","title":"Nash.best_reply","text":"best_reply(game::Dict{String,<:Array}, s::Vector{Vector{T}} where T<:Real,\nk::Int, epsil::F=0.0 ;return_val::String = \"array\") where F<:Real\n\nReturns best reply of given player to actions of his counterparts (defined by strategy profile) in the form of array or convex hull\n\nInput parameters\n\ngame::Dict{String,<:Array} - dictionary of players and their payoff matrices\ns::Vector{Vector{T}} where T<:Real - collection of actions probabilities for each player in a game\nk::Int - player for which the best reply is returned\nepsil::F = 0.0 - probability of error (if the answer is disturbed)\nreturn_val::String = \"array\" - type of returned value (\"array\" or \"chull\")\n\n\n\n\n\n","category":"function"},{"location":"reference/#Nash.is_nash_q","page":"Reference","title":"Nash.is_nash_q","text":"is_nash_q(game::Dict{String,<:Array}, s::Vector{Vector{T}}) where T<:Real\n\nReturns a dictionary of logical vectors indicating whether given profile is Nash equilibrium.\n\nInput parameters\n\ngame::Dict{String,<:Array} - dictionary of players and their payoff matrices\ns::Vector{Vector{T}}) - collection of actions probabilities for each player\n\n\n\n\n\n","category":"function"},{"location":"reference/#Nash.iterate_best_reply","page":"Reference","title":"Nash.iterate_best_reply","text":"iterate_best_reply(game::Dict{String,<:Array},\n        s::Vector{Vector{T}} where T<:Real,\n        epsil::F = 0.0, it_num::Int = 10)  where F<:Real\n\nReturns an array of arrays representing each players' game strategies (action probabilities) history in every iteration\n\nInput parameters\n\ngame::Dict{String,<:Array} - dictionary of players and their payoff matrices\ns::Vector{Vector{T}} where T<:Real - collection of actions probabilities for each player\nepsil::F = 0.0 - probability of error (if the answer is disturbed)\nit_num::Int = 10 - an integer specifying how many iterations should be repeated\n\n\n\n\n\n","category":"function"},{"location":"reference/#Markov-chains-1","page":"Reference","title":"Markov chains","text":"","category":"section"},{"location":"reference/#","page":"Reference","title":"Reference","text":"game2markov\r\nplot_markov","category":"page"},{"location":"reference/#Nash.game2markov","page":"Reference","title":"Nash.game2markov","text":"game2markov(game::Dict{String,<:Array}, s::Vector{Vector{T}}) where T<:Real\n\nReturns Markov chain of a given game and given vector of action probabilities\n\nInput parameters\n\ngame::Dict{String,<:Array} - dictionary of players and their payoff matrices\ns::Vector{Vector{T}} - collection of actions probabilities for each player\n\n\n\n\n\n","category":"function"},{"location":"reference/#Nash.plot_markov","page":"Reference","title":"Nash.plot_markov","text":"plot_markov(no_steps::Int, mc::MarkovChain{Int,Array{Int,2},Array{Int,1}})\n\nPlots a path of Markov chain simulation of a given time length and all initial values\n\nInput parameters\n\nno_steps::Int - scalar of time length (number of iterations)\nmc::MarkovChain{Int,Array{Int,2},Array{Int,1}} - Markov chain of a game (game2markov output function)\n\n\n\n\n\n","category":"function"},{"location":"#Nash.jl-1","page":"Nash.jl","title":"Nash.jl","text":"","category":"section"},{"location":"#","page":"Nash.jl","title":"Nash.jl","text":"Documentation for Nash.jl","category":"page"}]
}
