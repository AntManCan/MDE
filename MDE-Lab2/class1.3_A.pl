% A is connected to B and C
connected(lisbon, faro, porto).
connected(porto, coimbra, braga).
connected(coimbra, aveiro, viseu).

can_travel(X,Y, C):- connected(X,Y,_);connected(X,_,Y), C is 1.
can_travel(X,Y, C):- connected(X,Z,_);connected(X,_,Z),can_travel(Z,Y, S), C is S+1.

% How many cities I cross between Lisbon and aveiro

