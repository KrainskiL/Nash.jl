#######################
## Prepare libraries ##
#######################

# export JULIA_NUM_THREADS=4

BASE_FOLDER = pwd()
(basename(BASE_FOLDER) == "examples") && (BASE_FOLDER = dirname(BASE_FOLDER))
using Pkg
Pkg.activate(BASE_FOLDER)
# Install all required packages if not present
isfile(joinpath(BASE_FOLDER,"Manifest.toml")) || Pkg.instantiate()

using Combinatorics, Distributions, LightGraphs, LinearAlgebra, QuantEcon
using Roots, SymPy
using Nash

## Create game from provided payoff matrices
# Player 1 payoff matrix is
    # 1  0
    # 0  1
# Player 2 payoff matrix is
    # 1  0
    # 1  1
generate_game([1 0; 0 1], [1 0; 1 1])

## Generate random game for 2 players.
# First player has 2 actions and second player has 3 actions
# Payoffs are sampled from standard normal Distributions

random_2players_game(Normal(0,1),2,3)

## Generate random game for 3 players.
# First player has 2 actions, second player has 3 actions, third player has 3 actions
# Payoffs are sampled from Binomial distribution with 5 trials and p = 0.5

random_nplayers_game(Binomial(5,0.5),[2,3,3])

## Get payoffs for each player from given mixed strategy profiles
# Player 1 plays first and second action with p = 0.5
# Player 2 plays first action with p = 0.75 and second action with p = 0.25

game = random_nplayers_game(Binomial(5,0.5),[2,2]);
s = [[0.5,0.5],[0.75,0.25]]
s[1]'*game["player2"]*s[2]
get_payoff(game,s)

## Return best reply of first (k = 1) player
# with perturbation epsil=0.5
best_reply(generate_game([1 0; 0 1], [1 0; 0 1]), [[1.0, 0.], [0, 1]], 1, 0.5)
# no perturbation, with convex hull
a2 = best_reply(generate_game(Matrix(I,3,3), Matrix(I,3,3)), [[1/2,1/2,0],[1/3,1/3,1/3]], 1, return_val = "chull")
# plot best responses
plot_br(a2)

# Check if passed strategy is best response for each player and is it a Nash equilibrium
is_nash_q(generate_game([1 0 ; 0 1], [1 0; 0 1]), [[1, 0], [1, 0]])

# Iteratively find best reply with perturbation (epsil=1/3) and limit of 10 iterations
game = generate_game(Matrix(I, 3, 3), Matrix(I, 3, 3))
s = [[1/2,1/2, 0], [1/3,1/3,1/3]]
game_history = iterate_best_reply(game, s, 1/3, 10)


# Transform game into Markov Chain
game = generate_game(Matrix(1I, 3, 3), Matrix(I, 3, 3))
s = [[1, 0, 0],[0, 1, 0]]
mc = game2markov(game, s)
simulate(mc, 9, init = 3)
simulate(mc, 9) # random initial condition

is_irreducible(mc) # can we reach any state from any other state?
communication_classes(mc)
period(mc)
is_aperiodic(mc)
stationary_distributions(mc)
# TODO AS wizualizacja grafow
# TODO AS zaburzenia

plot_markov(10, mc)

# Generate random symmetric game
game = random_symmetric_2players_game(Binomial(10,1/2),2)

# Find necessary values to find symmetric nash equilibrium
x = symbols("x", real=true)
find_symmetric_nash_equilibrium_2players_game(game, [x, 1-x])

# Generate graph of relations that need to hold to make a game symmetric
actions_no_vector = [2, 2, 2];
graph = create_symmetries_graph(actions_no_vector)

# Check single relation
check_equality_condition(graph,((2,2,1),1), ((2,1,2),1))

# Find all needed relations
find_all_equalities(graph)

# counting vFunction - three players coordination game
pay = reshape([1 0 0 0 0 0 0 1], (2,2,2))
g1 = generate_game(pay, pay, pay)
vFunction(g1, [[1, 0], [1, 0], [1, 0]])
vFunction(g1, [[1, 0], [1, 0], [0, 1]])
