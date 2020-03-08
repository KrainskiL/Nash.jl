# Wykorzystamy pakiet distributions, by moc losowac z podstawowych
# rozkladow prawdopodobienstwa

using Distributions

# nawiasy kwadratowe przy wprowadzaniu danych - array, tuple - okragle
# poniewaz nie jest to az tak intuicyjne pisze to tak, by w obu przypadkach
# julia cos wyplula (jeśli tylko to, co zada uzytkownik ma sens)

# generowanie losowej gry, okreslone przez losowy rozklad i liczbe akcji
# konwersja tuple w array i ponownie array w tuple, gdyz reshape nie ma
# metody dla array

game = function(dist, actions)

reshape(rand(dist, prod(actions)*length(actions)),
Tuple(vcat(collect(actions), length(actions))))

end

gam1 = game(Normal(0, 1), (2, 3))
gam1

# okreslanie wyplat przy danych profilach strategii

strat1 = [1/2, 1/2]
strat2 = [1/2, 1/4, 1/2]

getpayoff = function(game, strat1, strat2)

temp = game.*(collect(strat1).*transpose(collect(strat2)))

# aby nie definiowac stale liczby graczy

temp2 = 1
for i = 2:(ndims(game) - 1)
temp2 = vcat(temp2, i)
end

sum(temp, dims = temp2)

end

pay = getpayoff(gam1, strat1, strat2)
pay

# payoffs jako funkcja

# wizualizacja dla 2 graczy - niestety nie mam zgrabne pomyslu/inspiracji
