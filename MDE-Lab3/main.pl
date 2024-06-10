:- consult('golog2_2024.pl').

def_isa :-
    new_relation(is_a, transitive, all, nil).

init_frames :-
    delete_kb,
    def_isa,
    frame_installation,
    frame_connection,
    frame_device,
    init_data.

frame_installation :-
    new_frame(installation),
    new_slot(installation,hiredPType),
    new_slot(installation,hiredPValue),
    new_slot(installation,sumPower,0),
    new_slot(installation,deviceList,[]),
    new_slot(installation,connectList,[]),
    new_slot(installation,viewDevicesPower,list_device_power), % FR4
    new_slot(installation,viewSumPower,view_installation_sumpower), % FR5
    new_slot(installation,alterHiredPower,alter_installation_power), % FR6
    new_demon(installation,sumPower,check_inst_sumP,if_write,after,side_effect). % FR7

% FR5 - Visualizar, consumo total de uma instalação.
view_installation_sumpower(F) :-
    get_value(F,sumPower,P),
    write('Current power consumption of ['),write(F),write(']: '),write(P),nl.

% FR 6 - Alterar potência contratada de uma instalação
alter_installation_power(F,Ptype,Pvalue) :-
    new_value(F,hiredPType,Ptype),
    new_value(F,hiredPValue,Pvalue).

% FR4 - Visualizar dispositivos por instalação, e consumo de cada um
% deles.
list_device_power(F) :-
    get_values(F,deviceList,LD),
    make_list_dpower(LD,[],LDC),
    write('Devices and power consumption of ['),write(F),write(']:'),
    write(LDC),nl.
make_list_dpower([H],LDCaux,LDC) :-
    !,get_value(H,power,P),
    append(LDCaux,[d(H:P)],LDC).
make_list_dpower([H|R],LDCaux,LDC) :-
    get_value(H,power,P),
    append(LDCaux,[d(H:P)],Li),
    make_list_dpower(R,Li,LDC).

% FR7
check_inst_sumP(F,sumPower,Sum,Sum) :-
    get_value(F,hiredPValue,P),
    (Sum > P) ->
    (write('ALERT: ['),write(F),write('] exceeded hired power!'),nl,
    write('Current Power Consumption: '),write(Sum),nl);
    true.

frame_connection :-
    new_frame(connection),
    new_slot(connection,inst_start),
    new_slot(connection,inst_end),
    new_slot(connection,cable_type),
    new_slot(connection,cable_material),
    new_slot(connection,cable_iso),
    new_slot(connection,length),
    new_slot(connection,loss_perc),
    new_slot(connection,alter_connection,altera_connection).

frame_device :-
    new_frame(device),
    new_slot(device,type),
    new_slot(device,power,0),
    new_slot(device,installed_in), % Name of installation device is installed in
    new_slot(device,installDevice,add_device_to_inst),
    new_slot(device,updatePower,alter_device_power).

init_data :-
    add_inst(instA,mono,6.9),
    add_inst(instB,tri,13.80),
    add_inst(instC,mono,13.80),
    add_inst(instD,mono,13.80),
    add_connection(instA,instB,rigido,cobre,pvc,10,2),
    add_connection(instA,instC,rigido,cobre,pvc,30,1),
    add_connection(instB,instC,rigido,cobre,pvc,15,4),
    add_connection(instB,instD,rigido,cobre,pvc,15,4),
    add_device(d16AM2,tv),
    add_device(d45TY1,frigo),
    add_device_to_inst(d16AM2,instA),
    add_device_to_inst(d45TY1,instA).

% RF2
% ==== INST OPERATIONS  ====
add_inst(Inst,PType,PValue) :-
    new_frame(Inst),
    new_slot(Inst,is_a,installation),
    new_value(Inst,hiredPType,PType),
    new_value(Inst,hiredPValue,PValue).

remove_inst(Inst) :-
    get_values(Inst,connectList,LR),
    length(LR,1),!,
    get_value(Inst,connectList,InstY),
    remove_connection(Inst,InstY),
    delete_frame(Inst).
remove_inst(Inst) :-
    get_value(Inst,connectList,InstY),
    remove_connection(Inst,InstY),
    remove_inst(Inst).

% ==== CONNECTION OPERATIONS ====
add_connection(InstX,InstY,CType,CMat,CIso,L,Loss) :-
    atom_concat(InstX,InstY,Connect),
    new_frame(Connect),
    new_slot(Connect,is_a,connection),
    new_value(Connect,inst_start,InstX),
    new_value(Connect,inst_end,InstY),
    new_value(Connect,cable_type,CType),
    new_value(Connect,cable_material,CMat),
    new_value(Connect,cable_iso,CIso),
    new_value(Connect,length,L),
    new_value(Connect,loss_perc,Loss),
    add_value(InstX,connectList,InstY),
    add_value(InstY,connectList,InstX).

remove_connection(InstX,InstY) :-
    delete_value(InstX,connectList,InstY),
    delete_value(InstY,connectList,InstX),
    atom_concat(InstX,InstY,C),
    (   (   frame_exists(C) -> delete_frame(C));
    (   atom_concat(InstY,InstX,C2),delete_frame(C2))).

altera_connection(F,NewX,NewY,CType,CMat,CIso,L,Loss) :-
    get_value(F,inst_start,InstX),
    get_value(F,inst_end,InstY),
    remove_connection(InstX,InstY),
    add_connection(NewX,NewY,CType,CMat,CIso,L,Loss).

% === DEVICE OPERATIONS ====
add_device(DRef,DType) :-
    new_frame(DRef),
    new_slot(DRef,is_a,device),
    new_value(DRef,type,DType).

add_device_to_inst(F,Inst) :-
    frame_exists(Inst),
    new_value(F,installed_in,Inst),
    add_value(Inst,deviceList,F).

remove_device(DRef) :-
    get_value(DRef,installed_in,Inst),
    delete_value(Inst,deviceList,DRef),
    delete_frame(DRef).

alter_device_power(F,PNew) :-
    get_value(F,installed_in,Inst),
    frame_exists(Inst),
    get_value(F,power,POld),
    new_value(F,power,PNew),
    get_value(Inst,sumPower,SumOld),
    SumNew is SumOld+PNew-POld,
    new_value(Inst,sumPower,SumNew).


% Error Messages
w_error(1):-
   write('Error! Operation failed.').

% Main Menu
trab3:- nl,nl,mainmenu(Op), mainexecute(Op).

mainmenu(Op):- write('====[ SEE Energy Management TM ]===='),nl,
               write('  1. Add/Remove/Edit/Show Installations'),nl,
               write('  2. Add/Remove/Edit/Show Devices'),nl,
               write('  3. Add/Remove/Edit/Show Connections'),nl,
               write('  4. Extra Options.'),nl,
               write('  5. Exit'),nl,
               write('====================================='),nl,mainreadoption(Op).

mainreadoption(Op):- read(Op), mainvalid(Op), nl.
mainreadoption(Op):- nl, write('Invalid Option!'), nl,  mainreadoption(Op).

mainvalid(Op):- Op >= 1, Op=<6.

mainexecute(5).
mainexecute(Op):- mainexec(Op), nl, mainmenu(NOp), mainexecute(NOp).

mainexec(1):-instmenu(IOp), instexecute(IOp).
mainexec(2):-devicemenu(IOp), deviceexecute(IOp).
mainexec(3):-connectmenu(IOp), connectexecute(IOp).
mainexec(4):-extramenu(IOp), extraexecute(IOp).

% Installation Menu
instmenu(IMOp):- write('====[ Installation Menu ]===='),nl,
               write('    1. Add installations.'),nl,
               write('    2. Remove installations.'),nl,
               write('    3. Edit installations.'),nl,
               write('    4. Show Installation.'),nl,
               write('    5. Go back.'),nl,
               write('============================='),nl, instreadoption(IMOp).

instreadoption(IROp):- read(IROp), instvalid(IROp), nl.
instreadoption(IROp):- nl, write('Invalid Inst Option!'), nl, instreadoption(IROp) .

instvalid(VOp):- VOp >= 1, VOp=<5.

instexecute(5).
instexecute(IOp):- instexec(IOp), nl, mainexec(1).

instexec(1):-write('Installation Name?'),nl,
             read(InstName),
             write('Power Type: (1) One or (3) Three-phase' ),nl,
             read(PowerType),
             %Validate Power Type
             (   (PowerType == 1) ->
             (   write('Power: 6.9, 10.35 or 13.80'),nl,
             write('Power: '),read(PowerM),add_inst(InstName, 'mono',PowerM));true),
             (   (PowerType == 3) ->
             (   write('Power: 13.80 or 20.7'),nl,
             write('Power: '),read(Power),add_inst(InstName, 'tri',Power))),
             write('Installation added successfully!').
instexec(1):-w_error(1).

instexec(2):-write('Installation Name?'),nl,
             read(InstName),
             remove_inst(InstName),
             write('Installation removed successfully!').
instexec(2):-w_error(1).

instexec(3):-write('Installation Name?'),nl,
             read(InstName),
             write('Select a new Power Type: (1) One or (3) Three-phase' ),nl,
             read(PowerType),
             %Validate Power Type
             (   (PowerType == 1) ->
             (   write('Power: 6.9, 10.35 or 13.80'),nl,
             write('Power: '),read(PowerM),nl,
                 call_method(InstName,alterHiredPower,[mono,PowerM]));true),
             (   (PowerType == 3) ->
             (   write('Power: 13.80 or 20.7'),nl,
             write('Power: '),read(Power),nl,
                 call_method(InstName,alterHiredPower,[tri,Power]))),
             write('Installation modified successfully!').
instexec(3):-w_error(1).

instexec(4):- write('Which installation should you see?'),nl,
              read(InstName),
              show_frame(InstName).
instexec(4):-w_error(1).

% Device Menu
devicemenu(DOp):-   write('============[ Device Menu ]============'),nl,
                    write('    1. Create a new device.')
                    write('    2. Add a device to an installation.'),nl,
                    write('    3. Remove a device.'),nl,
                    write('    4. Edit a device.'),nl,
                    write('    5. Show device.'),nl,
                    write('    6. Go back.'),nl,
                    write('======================================='),nl, devicereadoption(DOp).

devicereadoption(DOp):- read(DOp), devicevalid(DOp), nl.
devicereadoption(DOp):- nl, write('Invalid Device Option!'), nl,  devicereadoption(Op).

devicevalid(DOp):- DOp >= 1, DOp=<6.

deviceexecute(6).
deviceexecute(DOp):- deviceexec(DOp), nl, mainexec(2).

deviceexec(1):- write('Device Reference?'),nl,
                read(DRef),
                write('Device Name?'),nl,
                read(DName),
                add_device(DRef, DName),
                write('Device created successfully!').
deviceexec(1):-w_error(1).

deviceexec(2):- write('Device Ref?'),nl,
                read(DRef),
                write('Installation Name?'),nl,
                read(Inst)
                add_device_to_inst(DRef,Inst),
                write('Device added to installation!').
deviceexec(2):-w_error(1).

deviceexec(3):- write('Device Ref?'),nl,
                read(DRef),
                remove_device(DRef),
                write('Device removed successfully').
deviceexec(3):- w_error(1).

deviceexec(4):- write('Device Ref?'),nl,
                read(DRef),
                write('New Device Name? (write the same if no change)'),nl,
                read(NewDName),
                alteraDispositivo(DRef,NewDName, 0),
                write('Device modified successfully!').
deviceexec(4):-w_error(1).

deviceexec(5):- write('Which device should you see?'),nl,
                read(DRef),
                show_frame(DRef).
deviceexec(5):-w_error(1).


% Connection Menu
connectmenu(COp):-  write('====[ Connection Menu ]===='),nl,
                    write('    1. Add a Connection.'),nl,
                    write('    2. Remove a Connection.'),nl,
                    write('    3. Edit a Connection.'),nl,
                    write('    4. Show Connection.'),nl,
                    write('    5. Go back.'),nl,
                    write('==========================='),nl, connectreadoption(COp).

connectreadoption(COp):- read(COp), connectvalid(COp), nl.
connectreadoption(COp):- nl, write('Invalid Connection Option!'), nl,  connectreadoption(Op).

connectvalid(COp):- COp >= 1, COp=<5.

connectexecute(5).
connectexecute(COp):- connectexec(COp), nl, mainexec(3).

connectexec(1):-write('Source Installation name?'),nl,
             read(InstX),
             write('End Installation name?'),nl,
             read(InstY),
             write('Connection Type?'),nl,
             read(CType),
             write('Connection Material?'),nl,
             read(CMat),
             write('Connection Isolation?'),nl,
             read(CIso),
             write('Connection Length?'),nl,
             read(L),
             write('Connection Power Loss?'),nl,
             read(Loss),
             add_connection(InstX, InstY, CType, CMat, CIso, L, Loss),
             write('Connection added successfully!').
connectexec(1):-w_error(1).

connectexec(2):-write('Source Installation name?'),nl,
   read(InstX),
   write('End Installation name?'),nl,
   read(InstY),
   remove_connection(InstX, InstY),
   write('Connection removed successfully!').
connectexec(2):-w_error(1).

connectexec(3):-write('Source Installation name?'),nl,
   read(InstX),
   write('End Installation name?'),nl,
   read(InstY),
   atom_concat(InstX,InstY,C1),
   (   not(frame_exists(C1)) ->
   (atom_concat(InstY,InstX,C2),frame_exists(C2));true),
   write('New Start Installation name?'),nl,
   read(NewX),
   write('New End Installation name?'),nl,
   read(NewY),
   write('New Connection Length?'),nl,
   read(L),
   write('New Connection Power Loss?'),nl,
   read(Loss),
   write('New Connection Type?'),nl,
   read(CType),
   write('New Connection Material?'),nl,
   read(CMat),
   write('New Connection Isolation?'),nl,
   read(CIso),
   (   frame_exists(C1) ->
   call_method(C1,alter_connection,[NewX,NewY,CType,CMat,CIso,L,Loss]);
   (   frame_exists(C2) ->
   call_method(C2,alter_connection,[NewX,NewY,CType,CMat,CIso,L,Loss]))),
   write('Connection modified successfully!').
connectexec(3):-w_error(1).

connectexec(4):-write('Starting Installation?'),nl,
                read(InstX),
                write('End Installation?'),nl,
                read(InstY),
                atom_concat(InstX,InstY,C),
                show_frame(C).
connectexec(4):-w_error(1).

% Extra Menu
extramenu(LMOp):- write('====[ Extra Options ]===='),nl,
               write('    1. Show devices and power consumption by installation.'),nl,
               write('    2. Show total power consumption of an installation.'),nl,
               write('    3. Change Power Type of an Installation.'),nl,
               write('    4. Go back.'),nl,
               write('============================='),nl, extrareadoption(LMOp).

extrareadoption(LROp):- read(LROp), extravalid(LROp), nl.
extrareadoption(LROp):- nl, write('Invalid Extra Option!'), nl, extrareadoption(LROp) .

extravalid(VOp):- VOp >= 1, VOp=<4.

extraexecute(4).
extraexecute(IOp):- extraexec(IOp), nl, mainexec(4).

extraexec(1):-  write('Which installation would you like to show?'),nl,
                read(Inst),
                call_method(Inst,viewDevicesPower,[]).
extraexec(1):-w_error(1).

extraexec(2):-  write('Which installation would you like to show?'),nl,
                read(Inst),
                call_method(Inst,viewSumPower,[]).
extraexec(2):-w_error(1).

extraexec(3):-  write('Installation Name?'),nl,
                read(InstName),
                write('Power Type: (1) One or (3) Three-phase' ),nl,
                read(PowerType),
                %Validate Power Type
                (   (PowerType == 1) ->
                (   write('Power: 6.9, 10.35 or 13.80'),nl,
                write('Power: '),read(PowerM),call_method_2(InstName,alter_installation_power,'mono',PowerM));true),
                (   (PowerType == 3) ->
                (   write('Power: 13.80 or 20.7'),nl,
                write('Power: '),read(Power),call_method_2(InstName,alter_installation_power,'mono',Power))),
                write('Installation added successfully!').
extraexec(3):-w_error(1).
