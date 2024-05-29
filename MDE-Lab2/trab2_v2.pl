% potencia_contratada:monofasico 6.9, 10.35, 13.80; trifasico13.80,20.7
tipo_pot('monofasico', 6.9).
tipo_pot('monofasico', 10.35).
tipo_pot('monofasico', 13.80).

tipo_pot('trifasico', 13.80).
tipo_pot('trifasico', 20.7).

% dispositivo(nome, consumo_instantaneo).
dispositivo(ref,'frigorifico', 10).
dispositivo(ref,'tv', 5).

% instalacao(nome,tipo_pot(tipo, potencia contratada)).
% inst_pot_total(instalacao, consumo total).
% condutor_eletrico(tipo_cabo, material, isolamento).
condutor_eletrico('rigido', 'cobre', 'pvc').

% ligacao(inst origem, inst destino, condutor eletrico,
% comprimento, percentagem de perda).
% liga��o bidirecional
bid_l(X, Y,L) :- ligacao(X, Y, _, _, L).
bid_l(X, Y,L) :- ligacao(Y, X, _, _, L).

% addInst(nome instalacao, tipo potencia contratada, potencia).
:- dynamic instalacao/2.
:- dynamic inst_pot_total/2.
:- dynamic instLDispositivo/2.
addInst(Inst, Ptipo, Pnum) :-
    not(instalacao(Inst, _)),
    tipo_pot(Ptipo,Pnum),
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
    instalacao(Inst, tipo_pot(_, Pnum)),
    retract(instalacao(Inst, _)),
    tipo_pot(Ptipo,Pnum),
    assert(instalacao(Inst, tipo_pot(Ptipo, Pnum))).

alteraInstPnum(Inst,Pnum) :-
    instalacao(Inst, tipo_pot(Ptipo, _)),
    retract(instalacao(Inst, _)),
    tipo_pot(Ptipo,Pnum),
    assert(instalacao(Inst, tipo_pot(Ptipo, Pnum))).

alteraInstP(Inst,Pnum,Ptipo) :-
    retract(instalacao(Inst, _)),
    tipo_pot(Ptipo,Pnum),
    assert(instalacao(Inst, tipo_pot(Ptipo, Pnum))).

% addCondutor(tipo, material, isolamento).
:- dynamic condutor_eletrico/3.
addCondutor(T, M, I) :-
    (   not(condutor_eletrico(T, M, I))) ->
    assert(condutor_eletrico(T, M, I));
    true.

% addLigacao(inst origem, inst destino, tipo condutor, material
% condutor, isolamento condutor, comprimento, perdas percentagem).
:- dynamic ligacao/5.
addLigacao(InstX, InstY, Ctipo, Cmat, Ciso, L, P) :-
    (   not(bid_l(InstX, InstY,_)) ->
    (addCondutor(Ctipo,Cmat,Ciso),
    assert(ligacao(InstX, InstY, condutor_eletrico(Ctipo, Cmat, Ciso), L, P)))).

% removeLigacao(instX, instY).
removeLigacao(X, Y) :-
    bid_l(X,Y,_),
    retract(ligacao(Y, X, _,_,_)).
removeLigacao(X, Y) :-
    retract(ligacao(X, Y, _,_,_)).

% alteraLigacaoL(instX, instY,L).
alteraLigacaoL(X, Y, L) :-
    (   retract(ligacao(X,Y,C,_,P))) ->
    assert(ligacao(X,Y,C,L,P));
    (   retract(ligacao(Y,X,C,_,P))) ->
    assert(ligacao(Y,X,C,L,P)).

% alteraLigacaoP(instX, instY,P).
alteraLigacaoP(X, Y, P) :-
    (   retract(ligacao(X,Y,C,L,_))) ->
    assert(ligacao(X,Y,C,L,P));
    (   retract(ligacao(Y,X,C,L,_))) ->
    assert(ligacao(Y,X,C,L,P)).

% alteraLigacaoCtipo(instX, instY,Ctipo).
alteraLigacaoCtipo(X, Y, Ct) :-
    (   retract(ligacao(X,Y,condutor_eletrico(_, Cmat, Ciso),L,P))) ->
    (   addCondutor(Ct,Cmat,Ciso),
    assert(ligacao(X,Y,condutor_eletrico(Ct, Cmat, Ciso),L,P)));
    (   retract(ligacao(Y,X,condutor_eletrico(_, Cmat, Ciso),L,P))) ->
    (   addCondutor(Ct,Cmat,Ciso),
    assert(ligacao(Y,X,condutor_eletrico(Ct, Cmat, Ciso),L,P))).

% alteraLigacaoCmat(instX, instY,Ctipo).
alteraLigacaoCmat(X, Y, Cm) :-
    (   retract(ligacao(X,Y,condutor_eletrico(Ct, _, Ciso),L,P))) ->
    (   addCondutor(Ct,Cm,Ciso),
    assert(ligacao(X,Y,condutor_eletrico(Ct, Cm, Ciso),L,P)));
    (   retract(ligacao(Y,X,condutor_eletrico(Ct, _, Ciso),L,P))) ->
    (   addCondutor(Ct,Cm,Ciso),
    assert(ligacao(Y,X,condutor_eletrico(Ct, Cm, Ciso),L,P))).

% alteraLigacaoCiso(instX, instY,Ciso).
alteraLigacaoCiso(X, Y, Ci) :-
    (   retract(ligacao(X,Y,condutor_eletrico(Ct, Cmat, _),L,P))) ->
    (   addCondutor(Ct,Cmat,Ci),
    assert(ligacao(X,Y,condutor_eletrico(Ct, Cmat, Ci),L,P)));
    (   retract(ligacao(Y,X,condutor_eletrico(Ct, Cmat, _),L,P))) ->
    (   addCondutor(Ct,Cmat,Ci),
    assert(ligacao(Y,X,condutor_eletrico(Ct, Cmat, Ci),L,P))).

% addDispositivoInst(inst, dispositivo).
addDispositivoInst(Ref,Inst, Dname) :-
    instalacao(Inst, _),
    dispositivo(Ref,Dname, Dnum),
    instLDispositivo(Inst, L),
    not(member(Ref, L)),
    append([Ref], L, L1),
    retract(instLDispositivo(Inst,_)),
    assert(instLDispositivo(Inst,L1)),
    inst_pot_total(Inst, S1),
    S is S1+Dnum,
    retract(inst_pot_total(Inst, _)),
    assert(inst_pot_total(Inst, S)).

removeDispositivoInst(Ref,Inst, Dname) :-
    instalacao(Inst, _),
    dispositivo(Ref,Dname, Dnum),
    instLDispositivo(Inst, L),
    member(Ref, L),
    delete(L, Ref, L1),
    retract(instLDispositivo(Inst,_)),
    assert(instLDispositivo(Inst,L1)),
    inst_pot_total(Inst, S1),
    S is S1-Dnum,
    retract(inst_pot_total(Inst, _)),
    assert(inst_pot_total(Inst, S)).

% addDispositivo(disp name, consumo valor).
:- dynamic dispositivo/3.
addDispositivo(Ref,Dname, Cvalue) :-
    not(dispositivo(Ref,Dname, _)),
    assert(dispositivo(Ref,Dname, Cvalue)).

% removeDispositivo(disp name).
removeDispositivo(Ref) :-
    removeDispositivoInst(Ref,_,_),
    fail.
removeDispositivo(Ref) :-
    retract(dispositivo(Ref,_,_)).

% alteraDispositivo(Dname, Pnum).
addDtoListInst(_,_,[]).
addDtoListInst(Ref,Dname,[H|R]) :-
    addDispositivoInst(Ref,H,Dname),
    addDtoListInst(Ref,Dname,R).

alteraDispositivo(Ref,Dname, Pnum) :-
    listInstDType(Ref, Linst),
    removeDispositivo(Ref),
    addDispositivo(Ref,Dname,Pnum),
    addDtoListInst(Ref,Dname,Linst).

% listDispositivoInst(inst name, list L).
listDispositivoInst(Inst, L) :-
    instLDispositivo(Inst,L).

% RF6 - Listar consumo por dispositivo de instala��o
containInstLD(R, D, C, I) :-
    dispositivo(R, D, C),
    instLDispositivo(I, LD),
    member(R, LD).

listConsumoDInst(Inst, LC) :-
    findall((R,D,C),containInstLD(R,D,C,Inst), LC ).

% RF8 - Listar instala��es com dispositivos de um determinado tipo.
containDisp(I, R) :-
    instLDispositivo(I, LD),
    member(R, LD).

listInstDType(R, LI) :-
    findall(I, containDisp(I, R), LI).

% RF9 - Listar instala��o que mais consome na rede.
instMaiorConsumo(I) :-
    findall(C, inst_pot_total(_, C), LC),
    max_list(LC, CM),
    inst_pot_total(I, CM).

% RF10 - Obter itiner�rio el�trico entre duas instala��es.
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

% RF11 - Obter itiner�rio el�trico entre duas instala��es com passagem
% por uma ins%tala��o trif�sica.
listContainsTE(L,TE) :-
    not(   (member(arc(_:TE,_:_),L),member(arc(_:_,_:TE),L))) ->
    (   member(arc(_:TE,_:_),L);member(arc(_:_,_:TE),L));
    true.

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
% TE - Tipo Pot�ncia
bipath_tri(X,Y,p(TP),TE) :- step_tri(X,Y,[],TP,TE).


% RF12 - Obter itiner�rio el�trico entre duas instala��es cujo total de
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

% Main Menu
trab2:- nl,nl,mainmenu(Op), mainexecute(Op).

mainmenu(Op):- write('====[ SEE Energy Management TM ]===='),nl,
               write('  1. Add/Remove/Edit Installations'),nl,
               write('  2. Add/Remove/Edit Devices'),nl,
               write('  3. Add/Remove/Edit Connections'),nl,
               write('  4. Add/Remove/Edit Power Consumption'),nl,
               write('  5. List Options.'),nl,
               write('  6. Misc Operations'),nl,
               write('  7. Exit'),nl, 
               write('====================================='),nl,mainreadoption(Op).

mainreadoption(Op):- read(Op), mainvalid(Op), nl.
mainreadoption(Op):- nl, write('Invalid Option!'), nl,  mainreadoption(Op).

mainvalid(Op):- Op >= 1, Op=<7.

mainexecute(7).
mainexecute(Op):- mainexec(Op), nl, mainmenu(NOp), mainexecute(NOp).

mainexec(1):-instmenu(IOp), instexecute(IOp).
mainexec(2):-devicemenu(IOp), deviceexecute(IOp).
mainexec(3):-connectmenu(IOp), connectexecute(IOp).
mainexec(4):-powermenu(IOp), powerexecute(IOp).
mainexec(5):-
mainexec(6):-

% Installation Menu
instmenu(IOp):-write('====[ Installation Menu ]===='),nl,
               write('    1. Add installations.'),nl,
               write('    2. Remove installations.'),nl,
               write('    3. Edit installations.'),nl,
               write('    4. Go back.'),nl,
               write('============================='),nl, instreadoption(IOp).

instreadoption(IOp):- read(IOp), instvalid(IOp), nl.
instreadoption(Op):- nl, write('Invalid Inst Option!'), nl,  instreadoption(Op).

instvalid(IOp):- IOp >= 1, IOp=<4.

instexecute(4).
instexecute(IOp):- instexec(IOp), nl, instmenu(IOp), instexecute(IOp).

instexec(1):-write('Installation Name?'),nl,
             read(InstName),
             write('Power Type?'),nl,
             read(PowerType),
             %Validate Power Type
             write('Power?'),nl,
             read(Power),
             write('Power read.'),nl,
             addInst(InstName, PowerType,Power),
             write('Installation added successfully!').
instexec(2):-
instexec(3):-

% Device Menu
devicemenu(DOp):-   write('====[ Device Menu ]===='),nl,
                    write('    1. Add a device.'),nl,
                    write('    2. Remove a device.'),nl,
                    write('    3. Edit a device.'),nl,
                    write('    4. Go back.'),nl,
                    write('======================='),nl, devicereadoption(DOp).
                    
devicereadoption(DOp):- read(DOp), devicevalid(DOp), nl.
devicereadoption(DOp):- nl, write('Invalid Device Option!'), nl,  devicereadoption(Op).

devicevalid(DOp):- DOp >= 1, DOp=<4.

deviceexecute(4).
deviceexecute(DOp):- deviceexec(DOp), nl, devicemenu(DOp), deviceexecute(DOp).

deviceexec(1):-
deviceexec(2):-
deviceexec(3):-

% Connection Menu
connectmenu(COp):-  write('====[ Connection Menu ]===='),nl,
                    write('    1. Add a Connection.'),nl,
                    write('    2. Remove a Connection.'),nl,
                    write('    3. Edit a Connection.'),nl,
                    write('    4. Go back.'),nl,
                    write('==========================='),nl, connectreadoption(COp).
                    
connectreadoption(COp):- read(COp), connectvalid(COp), nl.
connectreadoption(COp):- nl, write('Invalid Connection Option!'), nl,  connectreadoption(Op).

connectvalid(COp):- COp >= 1, COp=<4.

connectexecute(4).
connectexecute(COp):- connectexec(COp), nl, connectmenu(COp), connectexecute(COp).

connectexec(1):-
connectexec(2):-
connectexec(3):-

% Power Menu
powermenu(POp):-  write('====[ Power Menu ]===='),nl,
                    write('    1. Add Power to a device.'),nl,
                    write('    2. Remove a Power.'),nl,
                    write('    3. Edit a Power.'),nl,
                    write('    4. Go back.'),nl,
                    write('========================'),nl, powerreadoption(POp).
                    
powerreadoption(POp):- read(POp), powervalid(POp), nl.
powerreadoption(POp):- nl, write('Invalid Power Option!'), nl,  powerreadoption(Op).

powervalid(POp):- POp >= 1, POp=<4.

powerexecute(4).
powerexecute(POp):- powerexec(POp), nl, powermenu(POp), powerexecute(POp).

powerexec(1):-
powerexec(2):-
powerexec(3):-