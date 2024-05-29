:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).

:- dynamic server_running/0.
start_server(Port) :-
    \+ server_running,
    assert(server_running),
    http_server(http_dispatch,[port(Port)]),!;
    true.

% Http service: Define endpoint ('/hello') and rule to trigger
% (say_hello)
:- http_handler('/hello',say_hello,[]).

:- http_handler('/numbers',numbers_handler,[]).

:- http_handler('/atoms',atoms_handler,[]).

:- http_handler('/facts',facts_handler,[]).

:- http_handler('/factslist',factslist_handler,[]).

say_hello(Request) :-
    member(search(Query),Request),
    memberchk(name=Name,Query),
    atom_concat("Hello: ",Name,MESSAGE),
    Response = _{ message: MESSAGE},
    reply_json(Response).

numbers_handler(_Request) :-
    Numbers = [1,2,3,4,5],
    dict_create(JSON,_,[numbers-Numbers]),
    reply_json(JSON).

atoms_handler(_Request) :-
    Atoms = [mde,str,si],
    maplist(atom_string,Atoms,Strings),
    reply_json(json([atoms=Strings])).

% Rule to create the JSON object
to_json(student(Name, Age),json([name=Name,age=Age])).

facts_handler(_Request) :-
    FactList = [student(andre,30), student(ines,25), student(filipa,40)],
    maplist(to_json,FactList,JSONList),
    reply_json(json([students=JSONList])).

factslist_handler(_Request) :-
    FactLists = [[student(andre,30), student(ines,25)], [student(filipa,40)]],
    maplist(maplist(to_json),FactLists,JSONLists),
    reply_json(JSONLists).
