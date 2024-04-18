connections(lisbon,faro).
connections(lisbon,porto).
connections(porto,coimbra).
connections(porto,braga).
connections(coimbra,aveiro).
connections(coimbra,viseu).

/*Only forwards*/
canitravel(O,P):- connections(O,P).
canitravel(O,P):- connections(Z,P), canitravel(O,Z).
/*Forwards and Backwards (Always works)*/
canitravel2(O,P):- connections(O,P).
canitravel2(O,P):-
    connections(Z,P),
    connections(Z,O).
    canitravel2(O,Z).

/*Count how many steps it took*/
canitravelcount(O,P,Steps):-
    /* Iniciatlizar a contagem a zero e dá o resultado final*/
    canitravelcount0(O,P,0,Steps).

canitravelcount0(O,P,Count,Steps):- 
    O == P,
    Steps is Count.

canitravelcount0(O,P,Count,Steps):- 
    connections(Z,P), 
    NewCount is Count + 1,
    canitravelcount0(O,Z,NewCount,Steps).

