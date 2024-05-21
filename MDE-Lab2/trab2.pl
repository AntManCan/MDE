

% potencia_contratada:monofasico 6.9, 10.35, 13.80; trifasico13.80,20.7
tipo_pot('monofasico', 6.9).
tipo_pot('monofasico', 10.35).
tipo_pot('monofasico', 13.80).

tipo_pot('trifasico', 13.80).
tipo_pot('trifasico', 20.7).

% dispositivo(nome, consumo_instantaneo).
dispositivo('frigorifico', 10).
dispositivo('tv', 5).

% instalacao(nome,tipo_pot(tipo, potencia contratada)).
instalacao('instA', tipo_pot('monofasico', 6.9)).
instalacao('instB', tipo_pot('monofasico', 10.35)).

% inst_pot_total(instalacao, consumo total).
inst_pot_total('instA', 0).

% condutor_eletrico(tipo_cabo, material, isolamento).
condutor_eletrico('rigido', 'cobre', 'pvc').

% ligacao(inst origem, inst destino, condutor eletrico,
% comprimento, percentagem de perda).
ligacao('instA', 'instB', condutor_eletrico('rigido', 'cobre', 'pvc'), 300, 10).

% ligação bidirecional
bid_l(X, Y,L) :- ligacao(X, Y, _, _, L).
bid_l(X, Y,L) :- ligacao(Y, X, _, _, L).

% addInst(nome instalacao, tipo potencia contratada, potencia).
:- dynamic instalacao/2.
:- dynamic inst_pot_total/2.
:- dynamic instLDispositivo/2.
addInst(Inst, Ptipo, Pnum) :-
    not(instalacao(Inst, _)),
    assert(instalacao(Inst, tipo_pot(Ptipo, Pnum))),
    not(inst_pot_total(Inst, _)),
    assert(inst_pot_total(Inst, 0)),
    not(instLDispositivo(Inst,_)),
    assert(instLDispositivo(Inst,[])).

% removeInst(nome inst).
removeInst(Inst) :-
    retract(ligacao(Inst, _, _,_,_)),
    fail.
removeInst(Inst) :-
    retract(ligacao(_,Inst , _,_,_)),
    fail.
removeInst(Inst) :-
    instalacao(Inst, _),
    retract(inst_pot_total(Inst, _)),
    retract(instLDispositivo(Inst, _)),
    retract(instalacao(Inst, _)),
    true.

alteraInstPtipo(Inst, Ptipo) :-
    retract(instalacao(Inst, tipo_pot(_, Pnum))),
    assert(instalacao(Inst, tipo_pot(Ptipo, Pnum))).

% addCondutor(tipo, material, isolamento).
:- dynamic condutor_eletrico/3.
addCondutor(T, M, I) :-
    not(condutor_eletrico(T, M, I)),
    assert(condutor_eletrico(T, M, I)).

% addLigacao(inst origem, inst destino, tipo condutor, material
% condutor, isolamento condutor, comprimento, perdas percentagem).
:- dynamic ligacao/5.
addLigacao(InstX, InstY, Ctipo, Cmat, Ciso, L, P) :-
    (   not(bid_l(InstX, InstY,_)) ->
    (addCondutor(Ctipo,Cmat,Ciso);
    assert(ligacao(InstX, InstY, condutor_eletrico(Ctipo, Cmat, Ciso), L, P)))).

% removeLigacao(instX, instY).
removeLigacao(X, Y) :-
    bid_l(X,Y,_),
    retract(ligacao(Y, X, _,_,_)).
removeLigacao(X, Y) :-
    retract(ligacao(X, Y, _,_,_)).

% addDispositivoInst(inst, dispositivo).
addDispositivoInst(Inst, Dname) :-
    instalacao(Inst, _),
    dispositivo(Dname, Dnum),
    instLDispositivo(Inst, L),
    not(member(Dname, L)),
    append([Dname], L, L1),
    retract(instLDispositivo(Inst,_)),
    assert(instLDispositivo(Inst,L1)),
    inst_pot_total(Inst, S1),
    S is S1+Dnum,
    retract(inst_pot_total(Inst, _)),
    assert(inst_pot_total(Inst, S)).

removeDispositivoInst(Inst, Dname) :-
    instalacao(Inst, _),
    dispositivo(Dname, Dnum),
    instLDispositivo(Inst, L),
    member(Dname, L),
    delete(L, Dname, L1),
    retract(instLDispositivo(Inst,_)),
    assert(instLDispositivo(Inst,L1)),
    inst_pot_total(Inst, S1),
    S is S1-Dnum,
    retract(inst_pot_total(Inst, _)),
    assert(inst_pot_total(Inst, S)).

% addDispositivo(disp name, consumo valor).
:- dynamic dispositivo/2.
addDispositivo(Dname, Cvalue) :-
    not(dispositivo(Dname, _)),
    assert(dispositivo(Dname, Cvalue)).

% listDispositivoInst(inst name, list L).
listDispositivoInst(Inst, L) :-
    instLDispositivo(Inst,L).


% RF6 - Listar consumo por dispositivo de instalação
containInstLD(D, C, I) :-
    dispositivo(D, C),
    instLDispositivo(I, LD),
    member(D, LD).

listConsumoDInst(Inst, LC) :-
    findall((D,C),containInstLD(D,C,Inst), LC ).

% RF8 - Listar instalações com dispositivos de um determinado tipo.
containDisp(I, D) :-
    instLDispositivo(I, LD),
    member(D, LD).

listInstDType(D, LI) :-
    findall(I, containDisp(I, D), LI).

% RF9 - Listar instalação que mais consome na rede.
instMaiorConsumo(I) :-
    findall(C, inst_pot_total(_, C), LC),
    max_list(LC, CM),
    inst_pot_total(I, CM).

% RF10 - Obter itinerário elétrico entre duas instalações.
addcond(PP, arc(X,Y,L), TP) :-
    not(member(arc(Y,X,_),PP)),
    append(PP,[arc(X,Y,L)],TP).

step(X,Y,PP,TP,L) :-
    bid_l(X,Y,L),!,
    addcond(PP,arc(X,Y,L),TP).
step(X,Y,PP,TP,L) :-
    bid_l(X,Z,L1),
    addcond(PP, arc(X,Z,L1),Pi),
    step(Z,Y,Pi,TP,L2),
    L is L1+L2.
bipath(X,Y,p(TP,TL)) :- step(X,Y,[],TP,TL).

% RF11 - Obter itinerário elétrico entre duas instalações com passagem
% por uma ins%talação trifásica.
listContainsTE(L,TE) :-
    member(arc(_:TE,_:_),L).
listContainsTE(L,TE) :-
    member(arc(_:_,_:TE),L).

addcond_tri(PP, arc(X:E1,Y:E2), TP) :-
    not(member(arc(Y:_,X:_),PP)),
    append(PP,[arc(X:E1,Y:E2)],TP).

step_tri(X,Y,PP,TP,TE) :-
    bid_l(X,Y,_),
    instalacao(X, tipo_pot(E1, _)),
    instalacao(Y, tipo_pot(E2, _)),!,
    addcond_tri(PP,arc(X:E1,Y:E2),TP),
    listContainsTE(TP,TE).
step_tri(X,Y,PP,TP,TE) :-
    bid_l(X,Z,_),
    instalacao(X, tipo_pot(E1, _)),
    instalacao(Z, tipo_pot(E2, _)),
    addcond_tri(PP,arc(X:E1,Z:E2),Pi),
    step_tri(Z,Y,Pi,TP,TE).
% TE - Tipo Potência
bipath_tri(X,Y,p(TP),TE) :- step_tri(X,Y,[],TP,TE).


% RF12 - Obter itinerário elétrico entre duas instalações cujo total de
% perdas sej%a inferior a 8%
step_l(X,Y,PP,TP,L,LL) :-
    bid_l(X,Y,L),!,
    addcond(PP,arc(X,Y,L),TP),
    L =< LL.
step_l(X,Y,PP,TP,L,LL) :-
    bid_l(X,Z,L1),
    addcond(PP, arc(X,Z,L1),Pi),
    step(Z,Y,Pi,TP,L2),
    L is L1+L2,
    L =< LL.
% LL - Limit losses
bipath_l(X,Y,p(TP,TL),LL) :- step_l(X,Y,[],TP,TL,LL).

