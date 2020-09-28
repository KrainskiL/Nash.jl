# Nash.jl

`Nash.jl` is a package providing selected functionalities from game theory field. The main package focus is to provide basic functions necessary to define games and finding Nash equilibria. It was created as part of academic algorithmic game theory course.


Tutorial
=========

## Games definition

`Nash.jl` defines game in package specific format. Currently there are 3 functions supporting game definition:
* `generate_game` - requires payoffs tensor as an argument to create game object (dictionary) with known payoffs values
* `random_2players_game` - creates game object for 2 players with payoffs sampled randomly from user-defined distribution (from `Distributions.jl` package)
* `random_nplayers_game` - creates game object for specified number of players with payoffs sampled randomly from provided distribution (from `Distributions.jl` package)

For 2-players game payoffs for player 1 are as follows:
* 1 if _player1_ plays first action and _player2_ plays first action
* 2 if _player1_ plays first action and _player2_ plays second action
* 2.5 if _player1_ plays second action and _player2_ plays first action
* 3 if _player1_ plays second action and _player2_ plays second action
following function call may be used (payoff scheme for player 2 is analogous):

```julia
generate_game([1 2; 2.5 3],[2 3;3.5 4])
> Dict{String,Array{Float64,2}} with 2 entries:
>  "player2" => [2.0 3.0; 3.5 4.0]
>  "player1" => [1.0 2.0; 2.5 3.0]
```

Generation of random 2-players game with payoffs drawn from normal distribution (mean - 0, std dev - 2), 2 actions for _player1_ and 3 actions for _player2_

```julia
using Distributions
random_2players_game(Normal(0,2),2,3)
> Dict{String,Array{Float64,2}} with 2 entries:
>  "player2" => [2.80393 -1.9793 -1.52571; -1.50642 -0.0574021 1.0391]
>  "player1" => [2.2755 -0.224079 0.0240092; 0.466656 -2.85657 2.40831]
```

Generation of random 3-players game with payoffs drawn from exponential distribution (mean - 3) and 2 actions for each player

```julia
using Distributions
using Random
Random.seed!(42);

game = random_nplayers_game(Exponential(2),[2,2,2])
> Dict{String,Array{Float64,3}} with 3 entries:
>  "player3" => [2.22898 0.133327; 2.9479 0.792779]…
>  "player2" => [7.32142 3.5243; 0.959199 0.619313]…
>  "player1" => [1.61285 0.307649; 1.20677 0.30259]…
```

## Payoff profile and best reply

To get payoff profile for game with mixed strategies use `get_payoff` function. Payoffs for previously-defined random 3-players game with 0.5 probability for all players actions are as follows:

```julia
get_payoff(game,[[0.5,0.5],[0.5,0.5],[0.5,0.5]])
> Dict{String,Float64} with 3 entries:
>  "player3" => 1.57951
>  "player2" => 2.58725
>  "player1" => 1.25779
```

`best_reply` function returns array or convex hull of best replies for `k`-th player in game with mixed strategies.

Best response for second player:

```julia
best_reply(game, [[0.5,0.5],[0.5,0.5],[0.5,0.5]],2)
> 1×2 Array{Int64,2}:
> 1  0
```

To use convex hull from `Polyhedra.jl` package use `return_val="chull"`. May be time-cosnuming.

```julia
best_reply(game, [[0.5,0.5],[0.5,0.5],[0.5,0.5]],2, return_val="chull")
```

## Nash equlibria

Given strategies profile for a game `is_nash_q` checks if the profile is a Nash equilibrium.

```julia
is_nash_q(game, [[0.5,0.5],[0.5,0.5],[0.5,0.5]])
```

To iteratively find best profile for each player use `iterate_best_reply` function. Additional disturbance parameter and number of iterations may be specified.

```julia
iterate_best_reply(game, [[0.5,0.5],[0.5,0.5],[0.5,0.5]],0.,20)
```

## Symmetric games

`random_symmetric_2players_game` generate random 2-players game with payoffs drawn from specified distribution

```julia
using Random
Random.seed!(42);
symgame = random_symmetric_2players_game(Normal(1,2),2)
> Dict{String,AbstractArray{Float64,2}} with 2 entries:
>  "player2" => [1.61285 1.20677; 0.307649 0.30259]
>  "player1" => [1.61285 0.307649; 1.20677 0.30259]
```

To find Nash equilibria for symmetric game:

```julia
find_symmetric_nash_equilibrium_2players_game(symgame, [SymPy.Sym(0.5),SymPy.Sym(0.5)])
```

To produce symmetries graph use:

```julia
g = create_symmetries_graph([2,2])
> [ Info: Created payout tensor: [((1, 1), 1), ((1, 1), 2), ((1, 2), 1), ((1, 2), 2), ((2, 1), 1), ((2, 1), 2), ((2, 2), 1), ((2, 2), 2)]
> Nash.SymmetriesGraph({8, 4} undirected simple Int64 graph, Dict(((2, 2), 2) => 8,((1, 1), 1) => 1,((1, 1), 2) => 2,((2, 1), 2) => 6,((1, 2), 2) => 4,((1, 2), 1) => 3,((2, 1), 1) => 5,((2, 2), 1) => 7), Dict(7 => ((2, 2), 1),4 => ((1, 2), 2),2 => ((1, 1), 2),3 => ((1, 2), 1),8 => ((2, 2), 2),5 => ((2, 1), 1),6 => ((2, 1), 2),1 => ((1, 1), 1)))
```

To check equality of two payouts in the graph:

```julia
check_equality_condition(g,((1, 1), 1),((2, 1), 1))
> false

check_equality_condition(g,((1, 1), 1),((1, 1), 2))
> true
```

To find all nodes with equal payout:

```julia
find_all_equalities(g)
> 4-element Array{Tuple{Tuple{Tuple{Int64,Int64},Int64},Tuple{Tuple{Int64,Int64},Int64}},1}:
> (((1, 1), 1), ((1, 1), 2))
> (((1, 2), 2), ((2, 1), 1))
> (((2, 2), 1), ((2, 2), 2))
> (((1, 2), 1), ((2, 1), 2))
```

## Replicator
To generate differential equations utilized for replicator for 2-player symmetric games:

```julia
using Random, Distributions, SymPy
Random.seed!(42);
game = random_symmetric_2players_game(Binomial(10,1/2), 2)
x = symbols("x", real = true)
create_replicator_eqs(game, [x, 1 - x])
```

For larger 2-player symmetric games:
```julia
game = random_symmetric_2players_game(Binomial(10,1/2), 4)
x = symbols("x", real = true)
y = symbols("y", real = true)
z = symbols("z", real = true)
create_replicator_eqs(game, [x, y, z, 1 - x - y - z])
```

Unfortunately, the most popular library for differential equations in Julia - [DifferentialEquations.jl](https://diffeq.sciml.ai/stable/) requires input in very specific form. To solve [ODE problem](https://diffeq.sciml.ai/stable/tutorials/ode_example/) it is neccessary to provide the equations warapped in a function bulit according to following syntax:
```julia
function lorenz!(du, u, p, t)
 du[1] = p[1] * (u[2] - u[1])
 du[2] = u[1] * (p[2] - u[3]) - u[2]
 du[3] = u[1] * u[2] - p[3] * u[3]
end
```
where ```du[i]``` represents each differential equation, ```p``` is the vector of coefficients and ```u``` is the vector of variables. It is non-trivial to automatically generate such function in a way that it can handle polynomials of any degree. What is more, DifferentialEquations.jl does not cooperate seamlessly with SymPy utilized for symbolic operations, which might be of help. Finally, multiple issues with stability of DifferentialEquations.jl were experienced.

## Markov chain analysis

Game may be also represented as Markov chain using `game2markov` function (for 2-player games).

```julia
using Random
Random.seed!(42);
game = random_2players_game(Normal(0,1),2,2)
mc = game2markov(game,[[0.5,0.5],[0.5,0.5]])
> Discrete Markov Chain stochastic matrix of type Array{Int64,2}:
> [0 1 0 0; 0 0 0 1; 1 0 0 0; 0 0 1 0]
```

To visualize results for 5 steps in produced Markov chain run:

```julia
plot_markov(5,mc)
```

![](https://i.ibb.co/zX2sRmt/Markov-Chain5.png)

## Advanced Nash equlibria optimization

`vFunction` checks difference between user-defined strategy profile and set of situations when all but i-th player plays defined strategy frofile and i-th player plays j-th pure action (where max(j) = number of player actions). If it is Nash Equilibrium - vFunction is equal to 0. 

```julia
vFunction(game,[[0.5,0.5],[0.5,0.5]])
> 0.421938354571314
```

By finding strategy profile minimizng vFunction to zero (via optimization) we may find Nash Equlibria. However, at the time being (09.2020) it is not possible to fully implement it without heavily modifing Julia optimization packages

The most promising at the time being is [Manopt.jl](https://github.com/JuliaManifolds/Manopt.jl) (Manifold Optimization)  using certain data types from
[Manifolds.jl](https://github.com/JuliaManifolds/Manifolds.jl). But not every manifold type from Manifolds.jl is supported/imported to that library
[as we can see](https://github.com/JuliaManifolds/Manopt.jl/blob/master/src/Manopt.jl) - especially not [Probability Simplex](https://github.com/JuliaManifolds/Manifolds.jl/blob/master/src/manifolds/ProbabilitySimplex.jl) crucial to finding NE through vFunction optimization.

Other packages are far less advanced - [JuMP](https://jump.dev/JuMP.jl/v0.21.1/installation/index.html) is a Julia frontend for various solvers and solver syntax is the best for that library.

[Optim.jl](https://julianlsolvers.github.io/Optim.jl/stable/#algo/manifolds/) at the time being supports only very simple manifold constraints and only for first-order algorithms.
