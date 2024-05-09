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

% liga��o bidirecional
bid_l(X, Y) :- ligacao(X, Y, _, _, _) ; ligacao(Y, X, _, _, _).

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

% addCondutor(tipo, material, isolamento).
:- dynamic condutor_eletrico/3.
addCondutor(T, M, I) :-
    not(condutor_eletrico(T, M, I)),
    assert(condutor_eletrico(T, M, I)).

% addLigacao(inst origem, inst destino, tipo condutor, material
% condutor, isolamento condutor, comprimento, perdas percentagem).
:- dynamic ligacao/5.
addLigacao(InstX, InstY, Ctipo, Cmat, Ciso, L, P) :-
    (   not(bid_l(InstX, InstY)) ->
    (addCondutor(Ctipo,Cmat,Ciso);
    assert(ligacao(InstX, InstY, condutor_eletrico(Ctipo, Cmat, Ciso), L, P)))).

% removeLigacao(instX, instY).
removeLigacao(X, Y) :-
    bid_l(X,Y),
    retract(ligacao(Y, X, _,_,_)),
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