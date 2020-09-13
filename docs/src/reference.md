Reference
=========

```@meta
CurrentModule = Nash
DocTestSetup = quote
    using Nash
end
```

Utilities
----------------------
```@docs
outer
plot_br
cart_prod_simplices
```

Games
----------------------
```@docs
generate_game
random_2players_game
random_nplayers_game
```

Equilibria and best responses
----------------------
```@docs
get_payoff
best_reply
is_nash_q
iterate_best_reply
vFunction
```

Markov chains
----------------------
```@docs
game2markov
plot_markov
```

Symmetric games
----------------------
```@docs
random_symmetric_2players_game
find_symmetric_nash_equilibrium_2players_game
create_symmetries_graph
check_equality_condition
find_all_equalities
```