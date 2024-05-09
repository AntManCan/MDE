order(305, date(11,10,2022),p45,20, delivery('R Raul Brandao,5','Almada')).
order(125, date(1,5,2022),p34,5, delivery('R Fernando Simoes,12','Caparica')).
order(235, date(4,2,2023),p34,16, delivery('R Raul Brandao,17','Almada')).

area(L,C,A):-A is L*C.
perimeter(L,C,P):-P is 2*(L+C).