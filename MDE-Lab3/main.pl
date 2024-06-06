:- consult('golog2_2024.pl').

def_isa :-
    new_relation(is_a, transitive, all, nil).

init_frames :-
    delete_kb,
    def_isa,
    frame_installation,
    frame_connection.

frame_installation :-
    new_frame(installation),
    new_slot(installation,hiredPType),
    new_slot(installation,hiredPValue),
    new_slot(installation,sumPower,0),
    new_slot(installation,deviceList,[]),
    new_slot(installation,connection,[]).

frame_connection :-
    new_frame(connection),
    new_slot(connection,inst_start),
    new_slot(connection,inst_end),
    new_slot(connection,cable_type),
    new_slot(connection,cable_material),
    new_slot(connection,cable_iso),
    new_slot(connection,length),
    new_slot(connection,loss_perc).

% RF1
add_inst(Inst,PType,PValue) :-
    new_frame(Inst),
    new_slot(Inst,is_a,installation),
    new_value(Inst,hiredPType,PType),
    new_value(Inst,hiredPValue,PValue).

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
    new_value(Connect,loss_perc,Loss).
