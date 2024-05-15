:-dynamic vendedor/2.
:-dynamic cliente/2.
:-dynamic transportador/4.
:-dynamic ligacao/3.
:-dynamic produto/3.


vendedor(a,lisboa).
vendedor(d,lisboa).
vendedor(b,leiria).
vendedor(c,porto).
vendedor(e,leiria).


cliente(f,lisboa).
cliente(i,lisboa).
cliente(h,leiria).
cliente(g,porto).

produto(banana, a, 110).
produto(laranja, a, 80).
produto(melancia, a, 85).
produto(banana, b, 140).
produto(melancia, d, 93).
produto(laranja, c, 120).

ligacao( a, d, 35).
ligacao( a, f, 25).
ligacao( a, b, 70).
ligacao( d, e, 15).
ligacao( f, e, 20).
ligacao( b, h, 15).
ligacao( b, c, 70).
ligacao( e, h, 60).
ligacao( c, g, 20).
ligacao( e, i, 30).

transportador(mota, 170, 20, 30).
transportador(carro, 150, 55, 85).
transportador(camião, 110, 110, 150).
transportador(scooter, 140, 20, 25).





distancia(X,Y,D):-
    ligacao(X,Y,D).
distancia(X,Y,D):-
    distancia(X,Z,D1), distancia(Z,Y,D2),
    D is D1+D2.




%assert(vendedor(A,Local)).
%assert(cliente(A,Local)).
%assert(produto(Nome, Loja, Quantidade)).
%assert(ligacao(A, B, Dist)).
%assert(transportador(Veiculo,Velocidade, VolumeM, PesoM)).

alterar_vendedor(A1, Local1, A2, Local2):- vendedor(A1,Local1),
    retract(vendedor(A1,Local1)),
    assert(vendedor(A2, Local2)).
alterar_cliente(A1, Local1, A2, Local2):- cliente(A1,Local1),
    retract(cliente(A1,Local1)),
    assert(cliente(A2, Local2)).
alterar_quantidade_produto(Nome,Loja, Quantidade):- produto(Nome,Loja,_),
    retract(produto(Nome,Loja,_)),
    assert(produto(Nome,Loja,Quantidade)).

alterar_transportador_velocidade(Veiculo, Velocidade):-transportador(Veiculo,_,A,B),
    retract(transportador(Veiculo,_,A,B)),
    assert(transportador(Veiculo,Velocidade,A,B)).
alterar_transportador_volume(Veiculo, Volume):-transportador(Veiculo,A,_,B),
    retract(transportador(Veiculo,A,_,B)),
    assert(transportador(Veiculo,A,Volume,B)).
alterar_transportador_peso(Veiculo, Peso):-transportador(Veiculo,A,B,_),
    retract(transportador(Veiculo,A,B,_)),
    assert(transportador(Veiculo,A,B,Peso)).

alterar_rota_ponto_A(A1,B,A2,D):- ligacao(A1,B,_),
    retract(ligacao(A1,B,_)),
    assert(ligacao(A2,B,D)).
alterar_rota_ponto_B(A,B1,B2,D):- ligacao(A,B1,_),
    retract(ligacao(A,B1,_)),
    assert(ligacao(A,B2,D)).
alterar_rota_distancia(A,B,D1,D2):- ligacao(A,B,D1),
    retract(ligacao(A,B,D1)),
    assert(ligacao(A,B,D2)).




remover_vendedor(N,L):- vendedor(N,L),
    retract(vendedor(N,L)).
remover_cliente(N,L):- cliente(N,L),
    retract(cliente(N,L)).
remover_produto(N,L):- produto(N,L,_),
    retract(produto(N,L,_)).
remover_transportador(N):- transportador(N,_,_,_),
    retract(transportador(N,_,_,_)).
remover_rota(A,B):- ligacao(A,B,_),
    retract(ligacao(A,B,_)).




maxSpeed(S):-findall(Speed, transportador(_,Speed,_,_), ST), max(ST,S).

%mindist(X,Y,D):-findall(Di, distancia(X,Y,Di),LDi), min(LDi,D).

min([X],X).
min([E|R],E):-
    min(R,M),
    E=<M.
min([E|R],M):-
    min(R,M),
    E>M.


max([X],X).
max([E|R],E):-
    max(R,M),
    E>=M.
max([E|R],M):-
    max(R,M),
    E>M.



findalldist(X,Y,LD):-
    findall(D, distancia(X,Y,D), LD).

findall_produto_vendedor(P,LV):-
    findall(V, produto(P,V,_), LV).

findadistmin(X,Y,D):-
    findalldist(X,Y,L),
    min(L,D).

path(X,Y,[ligacao(X,Y,D)]):-
    ligacao(X,Y,D).
path(X,Y,[ligacao(X,Z,D1)|R]):-
    ligacao(X,Z,D1),
    path(Z,Y,R).

path(X,Y,pd([ligacao(X,Y,D1)|R],DT)):-
    ligacao(X,Z,D1),
    pathDist(Z,Y,pd(R,D2)),
    DT is D1 + D2.


pathM(X,M,Y,[ligacao(X,Y,D)]):-
    ligacao(X,M,D1),
    ligacao(M,Y,D2),
    D is D1+D2.
pathM(X,M,Y,[ligacao(X,M,D)|R]):-
    ligacao(X,M,D1),
    ligacao(X,Z,D2),
    path(Z,Y,R),
    D is D1 + D2.
pathM(X,M,Y,pd([ligacao(X,Y,D1)|R],DT)):-
    ligacao(X,M,D1),
    ligacao(M,Z,D2),
    pathDist(Z,Y,pd(R,D3)),
    DT is D1 + D2 + D3.




pathDist(X,Y,p([ligacao(X,Y,D)],D)):-
    ligacao(X,Y,D).
pathDist(X,Y,p([ligacao(X,Y,D1)|R],DT)):-
    ligacao(X,Z,D1),
    pathDist(Z,Y,p(R,D2)),
    DT is D1 + D2.



lastElement([Head]):- write(Head).
lastElement([_|Tail]):-lastElement(Tail).

transporteDisp(M,[transportador(T,S,V,P)]):- transportador(T,S,V,P), S>M.
transporteDisp(M,[transportador(T,S,V,P)|R]):- transportador(T,S,V,P), S>M, transporteDisp(M,R).



biarc(X,Y,D):-ligacao(X,Y,D).
biarc(X,Y,D):-ligacao(Y,X,D).

pass_once(X,Y,TP,TD):-stepnr(X,Y,[],TP,0,TD).
stepnr(CP,FP,PP,TP,PD,TD):-biarc(CP,FP,D),
                    addnorep(PP,ligacao(CP,FP,D),TP),
                    TD is PD + D.
stepnr(CP,FP,PP,TP,PD,TD):-biarc(CP,NP,D),
                          addnorep(PP,dist(CP,NP,D),Pi),
                          Di is PD + D,
                          stepnr(NP,FP,Pi,TP,Di,TD).
addnorep(PP,dist(P1,P2,D),Pi):-not(passed(PP,P2)),
                              conc(PP,[dist(P1,P2,D)],Pi).

passed([ligacao(P,_,_)|_],P).
passed([ligacao(_,P,_)|_],P).
passed([_|R],P):-passed(R,P).

conc([],L,L).
conc([C|R],L,[C|T]):-conc(R,L,T).

concatenate(List1,List2,R):-append(List1,List2,R).




menu_title :- nl,
    write('Bemvindo à sua loja Favorita'),
    nl,
    menu(Op),
    execute(Op).

menu(Op) :-write('1 -> Listar Factos'),nl,
    write('2 -> Adicionar Factos'),nl,
    write('3 -> Alterar Factos'),nl,
    write('4 -> Remover Factos'),nl,
    write('5 -> Exit'),nl,
    read(Op).

execute(Op):- exec(Op,_), nl, menu(NOp), execute(NOp).

exec(1,_):-write('1 -> Listar Todas as Rotas'),nl,
    write('2 -> Listar Todos os Vendedores'), nl,
    write('3 -> Listar Todos os Transportadores'), nl,
    write('4 -> Listar Todos os Clientes'), nl,
    write('5 -> Listar Todos os Produtos'), nl,
    write('6 -> Listar Todos os Vendedores de Produto X'), nl,
    write('7 -> Listar Todas as possibilidades de transporte entre dois vendedores adjacentes da rede'), nl,
    write('8 -> Listar Todos as possibilidades de transporte considerando a distancia'), nl,
    write('9 -> Listar Transportes possiveis entre vendedor e cliente da rede'), nl,
    write('10 -> Indicar a distancia, tempo e melhor transporte entre vendedor e cliente'), nl,
    read(Op2), nl,
    listar(Op2,_,_,_).


exec(2,Op2):-write('1 -> Adicionar Vendedor'),nl,
    write('2 -> Adicionar Produto'), nl,
    write('3 -> Adicionar Transporte'), nl,
    write('4 -> Adicionar Rota'), nl,
    write('5 -> Adicionar Cliente'), nl,
    read(Op2), nl,
    addFact(Op2,_,_,_,_).

exec(3,Op2):-write('1 -> Alterar Vendedor'),nl,
    write('2 -> Alterar a Quantidade de um Produto'), nl,
    write('3 -> Alterar Velocidade de um Transporte'), nl,
    write('4 -> Alterar Volume Maximo de um Transporte'), nl,
    write('5 -> Alterar Peso Maximo de um Transporte'), nl,
    write('6 -> Alterar ponto inicial de uma rota'), nl,
    write('7 -> Alterar ponto final de uma rota'), nl,
    write('8 -> Aletrar a distancia entre dois pontos de uma rota'), nl,
    write('9 -> Alterar Cliente'), nl,
    read(Op2), nl,
    alterarFacto(Op2,_,_,_,_).

exec(4,Op2):-write('1 -> Remover Vendedor'),nl,
    write('2 -> Remover Produto'), nl,
    write('3 -> Remover Transporte'), nl,
    write('4 -> Remover Rota'), nl,
    write('5 -> Remover Cliente'), nl,
    read(Op2), nl,
    removerFacto(Op2,_,_).


exec(5,_). /*finish execution*/




listar(1,_,_,_):-listing(ligacao).
listar(2,_,_,_):-listing(vendedor).
listar(3,_,_,_):-listing(transportador).
listar(4,_,_,_):-listing(cliente).
listar(5,_,_,_):-listing(produto).

listar(6,P,_,_):-write('Qual o produto desejado?'),nl,
    read(P),
    findall_produto_vendedor(P,L),
    print(L), nl.
listar(7,V1,V2,_):-write('introduza o vendedor 1 e o vendedor 2'),nl,
    read(V1), read(V2),
    vendedor(V1,_), vendedor(V2,_),
    path(V1,V2,P),
    findall(T, transportador(T,_,_,_), H),
    Result = {P,H},
    print(Result).

listar(8,V1,V2,_):-write('introduza o vendedor 1 e o vendedor 2'),nl,
    read(V1), read(V2),
    vendedor(V1,_), vendedor(V2,_),
    pathDist(V1,V2,P),
    findall(T, transportador(T,_,_,_), H),
    Result = {P, H},
    print(Result).

listar(9,V1,V2,C):-write('introduza o vendedor 1, vendedor 2 e o cliente'),nl,
    read(V1), read(V2), read(C),
    vendedor(V1,_), vendedor(V2,_), cliente(C,_),
    pathM(V1,V2,C,P),
    findall(T, transportador(T,_,_,_), H),
    Result = {P, H},
    print(Result).

listar(10,V,C,_):-write('introduza o vendedor e o cliente'),nl,
    read(V), read(C),
    vendedor(V,_), cliente(C,_),
    findadistmin(V,C,Min),
    maxSpeed(S),
    Tempo is Min/S ,
    transportador(N,S,_,_),
    Result = {'distancia = ',Min,'transporte= ', N, 'tempo= ', Tempo},
    print(Result).






addFact(1,N,L,_,_):- write('introduza o Nó e a Localidade'), nl,
    read(N), read(L),
    not(vendedor(N,L)), assertz(vendedor(N,L)).

addFact(2,N,L,Q,_):- write('introduza o nome do Produto, a Loja e a Quantidade'), nl,
    read(N), read(L), read(Q),
    vendedor(L,_), not(produto(N,L,_)), assertz(produto(N,L,Q)).

addFact(3,T,S,V,P):- write('introduza o Tipo de Transporte, a velocidade, o volume maximo e o Peso maximo'), nl,
    read(T), read(S), read(V), read(P),
    not(tansportador(T,_,_,_)), assertz(transportador(T,S,V,P)).

addFact(4,A,B,D,_):- write('introduza o Ponto inicial, o Ponto final e a distancia entre eles)'), nl,
    read(A), read(B), read(D),
    not(ligacao(A,B,_)), assertz(ligacao(A,B,D)).

addFact(5,N,L,_,_):- write('introduza o Nó e a Localidade'), nl,
    read(N), read(L), not(cliente(N,L)), assertz(cliente(N,L)).



alterarFacto(1,N1,L1,N2,L2):- write('introduza o antigo Nó e Localidade do vendedor'), nl,
    read(N1), read(L1),
    vendedor(N1,L1),
    write('introduza o novo Nó e a nova  Localidade do vendedor'),nl,
    read(N2), read(L2),
    alterar_vendedor(N1,L1,N2,L2).


alterarFacto(2,N,L,Q,_):- write('introduza o nome do Produto, a Loja e a nova Quantidade'), nl,
    read(N), read(L),
    vendedor(L,_), produto(N,L,_),
    read(Q),
    alterar_quantidade_produto(N,L,Q).





alterarFacto(3,T,S,_,_):- write('introduza o Tipo de Transporte e a nova velocidade'), nl,
    read(T), read(S),
    alterar_transportador_velocidade(T,S).
alterarFacto(4,T,V,_,_):- write('introduza o Tipo de Transporte e o novo volume maximo'), nl,
    read(T), read(V),
    alterar_transportador_volume(T,V).
alterarFacto(5,T,P,_,_):- write('introduza o Tipo de Transporte e o novo Peso maximo'), nl,
    read(T), read(P),
    alterar_transportador_peso(T,P).



alterarFacto(6,A1,B,A2,D):- write('introduza o Ponto inicial antigo, o Ponto final, o novo Ponto inicial e a nova distancia entre eles)'), nl,
    read(A1), read(B), read(A2), read(D),
    alterar_rota_ponto_A(A1,B,A2,D).
alterarFacto(7,A,B1,B2,D):- write('introduza o Ponto inicial, o Ponto final antigo, o novo Ponto final e a nova distancia entre eles)'), nl,
    read(A), read(B1), read(B2), read(D),
    alterar_rota_ponto_B(A,B1,B2,D).
alterarFacto(8,A,B,D1,D2):- write('introduza o Ponto inicial, o Ponto final, a antiga e a nova distancia entre eles)'), nl,
    read(A), read(B), read(D1), read(D2),
    alterar_rota_distancia(A,B,D1,D2).



alterarFacto(9,N1,L1,N2,L2):- write('introduza o antigo Nó e Localidade do Cliente'), nl,
    read(N1), read(L1),
    cliente(N1,L1),
    write('introduza o novo Nó e a nova  Localidade do cliente'),nl,
    read(N2), read(L2),
    alterar_cliente(N1,L1,N2,L2).







removerFacto(1,N,L):- write('introduza o Nó e a Localidade do vendedor a remover'), nl,
    read(N), read(L),
    remover_vendedor(N,L).

removerFacto(2,N,L):- write('introduza o nome do Produto e a Loja do produto a ser removido'), nl,
    read(N), read(L),
    remover_produto(N,L).

removerFacto(3,T,_):- write('introduza o Tipo do Transporte a ser removido'), nl,
    read(T),
    remover_transportador(T).

removerFacto(4,A,B):- write('introduza o Ponto inicial e o Ponto final da rota a ser removida)'), nl,
    read(A), read(B),
    remover_rota(A,B).

removerFacto(5,N,L):- write('introduza o Nó e a Localidade do cliente a ser removido'), nl,
    read(N), read(L),
     remover_cliente(N,L).

