/* Maria is fatter than Ana */
heavier(maria, ana).
heavier(ana, luisa).
heavier(luisa, diana).
heavier(diana, sara).

fatter(O, P):-heavier(O, P).
fatter(O, P):-heavier(Z, P), fatter(O, Z).