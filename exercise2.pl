heavier(maria,ana).
heavier(ana,luisa).
heavier(luisa,diana).
heavier(diana,sara).

heavierthan(O,P):- heavier(O,P).
heavierthan(O,P):- heavier(Z,P),heavierthan(O,Z).