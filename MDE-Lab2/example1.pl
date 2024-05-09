% From theoretical class
part(robot,base).
part(robot,arm).
part(robot,griper).
part(robot,controller).

part(griper,wrist).
part(griper,fingers).
part(griper,sensor).

includes(O,P) :- part(O,P).
includes(O,P) :- part(O,Z), part(Z,P).