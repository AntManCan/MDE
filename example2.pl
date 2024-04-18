/* name, load, opening, power form */
griper(g1,2,5,electric).
griper(g2,1.5,4,pneumatic).
griper(g3,2,6,pneumatic).

/* name, weight, width */
component(pl,1.5,4).
component(p2,2,6).


find_griper(C,G):-
    component(C,P,Lc),
    griper(G,P,Lg,_),
    Lc=<Lg.