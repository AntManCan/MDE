:- ensure_loaded('golog2_2024.pl').
create_vehicle:-

new_frame(vehicle),
new_slot(vehicle, position),
new_values(vehicle, position,[15,8]),
new_slot(vehicle, move_x,4),
new_slot(vehicle, move_y,7).


new_relation(on_top_of,transitive,inclusion([position]),under).
new_frame(load).
new_slot(load,on_top_of,vehicle).

