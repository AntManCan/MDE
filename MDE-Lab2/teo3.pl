
arc(a,b).
arc(a,c).
arc(b,d).
arc(c,d).
arc(c,e).

connected(X,Y):-arc(X,Y).
connected(X,Y):-arc(X,Z),connected(Z,Y).

% LISTS
% [] - empty list
% [a, b, c] - list with 3 elements
% [a, [b, c], d] - list with 3 elements
% [H | R] - list with head element H
% findall(V, query, LA)
% Prolog has preset functions for lists
