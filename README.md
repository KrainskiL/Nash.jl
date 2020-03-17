# Nash.jl
Implementation of Games Theory algorithms in Julia

**Documentation**

[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://krainskil.github.io/Nash.jl/dev)

**Build status**

[![Build Status](https://travis-ci.org/KrainskiL/Nash.jl.svg?branch=master)](https://travis-ci.org/KrainskiL/Nash.jl)
[![codecov](https://img.shields.io/codecov/c/gh/KrainskiL/Nash.jl.svg)](https://codecov.io/gh/KrainskiL/Nash.jl)

**Instalation instructions**

Add Nash using Pkg

```julia
] add https://github.com/KrainskiL/Nash.jl
```

**Example usage**

```julia
using Nash
using Distributions
random_2players_game(Normal(0,2),2,3)
> Dict{String,Array{Float64,2}} with 2 entries:
>  "player2" => [2.80393 -1.9793 -1.52571; -1.50642 -0.0574021 1.0391]
>  "player1" => [2.2755 -0.224079 0.0240092; 0.466656 -2.85657 2.40831]
```
