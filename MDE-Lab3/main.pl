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

% FR5 - Visualizar, consumo total de uma instala��o.
view_installation_sumpower(F) :-
    get_value(F,sumPower,P),
    write('Current power consumption of ['),write(F),write(']: '),write(P),nl.

% FR 6 - Alterar pot�ncia contratada de uma instala��o
alter_installation_power(F,Ptype,Pvalue) :-
    new_value(F,hiredPType,Ptype),
    new_value(F,hiredPValue,Pvalue).

% FR4 - Visualizar dispositivos por instala��o, e consumo de cada um
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
    new_slot(connection,loss_perc).

frame_device :-
    new_frame(device),
    new_slot(device,ref),
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
