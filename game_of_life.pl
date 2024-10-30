% Conway's game of life, written entirely in Prolog.

cell(live).
cell(dead).

coord(Integer, Integer).

% given coord get cell from grid
% grid can't be defined as data type cos annoying prolog

get_cell(_, [], _).
get_cell(coord(X1,Y1), Grid, Cell) :-
    length(Grid, Height),
    normalise(Y1, Height, Y2),
    nth0(Y2, Grid, Row),

    length(Row, Width),
    normalise(X1, Width, X2),
    nth0(X2, Row, Cell).

normalise(N1, Max, N2) :-
    ( N1 >= Max ->
      N2 is N1 rem Max
    ; N1 \= 0, N1 < 0 ->
      N2 is Max + (N1 rem Max)
    ; N2 is N1
    ).

get_surrounding(_, [], []).
get_surrounding(coord(X,Y), Grid, Cells) :-
    get_cell(coord(X-1,Y-1), Grid, Cell1),
    get_cell(coord(X,Y-1), Grid, Cell2),
    get_cell(coord(X+1,Y-1), Grid, Cell3),
    get_cell(coord(X-1,Y), Grid, Cell4),
    get_cell(coord(X+1,Y), Grid, Cell5),
    get_cell(coord(X-1,Y+1), Grid, Cell6),
    get_cell(coord(X,Y+1), Grid, Cell7),
    get_cell(coord(X+1,Y+1), Grid, Cell8),
    Cells = [Cell1, Cell2, Cell3, Cell4, Cell5, Cell6, Cell7, Cell8].

update_cell(_,_,[],_).
update_cell(cell(State), coord(X, Y), Grid, cell(NewState)) :-
    get_surrounding(coord(X,Y), Grid, SCells),
    exclude(=(dead), SCells, LiveCells),
    length(LiveCells, NumLive),

    ( State = live, NumLive < 2 ->
      NewState = dead
    ; State = live, (NumLive = 2 ; NumLive = 3) ->
      NewState = live
    ; State = live, NumLive > 3 ->
      NewState = dead
    ; State = dead, NumLive = 3 ->
      NewState = live
    ; NewState = State
    ).

update_row([], _, _, []).
update_row([State|States], Grid, coord(X,Y), [NewState|NewRow]) :-
  update_cell(cell(State), coord(X,Y), Grid, cell(NewState)),
  X2 is X + 1,
  update_row(States, Grid, coord(X2,Y), NewRow).

update_grid(Grid, NewGrid) :-
  update_grid(Grid, Grid, coord(0,0), NewGrid).

update_grid([], _, _, []).
update_grid([Row|Rows], Grid, coord(X,Y), [NewRow|NewGrid]) :-
  update_row(Row, Grid, coord(X,Y), NewRow),
  Y2 is Y + 1,
  update_grid(Rows, Grid, coord(0, Y2), NewGrid).

replace(_, _, [], []).
replace(E1, E2, [H1|T1], [H2|T2]) :-
  ( H1 = E1 ->
    H2 = E2
  ; H2 = H1
  ),
  replace(E1, E2, T1, T2).

print_grid([]).
print_grid([H1|T]) :-
  replace(live, '#', H1, H2),
  replace(dead, ' ', H2, H3),
  atomic_list_concat(H3, Line),
  writeln(Line),
  print_grid(T).

run(Grid, Delay) :-
  print_grid(Grid),
  sleep(Delay),
  update_grid(Grid, NewGrid),
  run(NewGrid, Delay).

run_game() :-
  example(Grid),
  run(Grid, 0.25).

example(
  [ [dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead],
    [dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead],
    [dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead],
    [dead, dead, dead, dead, live, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead],
    [dead, dead, dead, live, dead, live, dead, dead, dead, dead, dead, dead, dead, dead, dead],
    [dead, dead, dead, dead, live, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead],
    [dead, dead, dead, dead, dead, dead, dead, dead, live, live, dead, dead, dead, dead, dead],
    [dead, dead, dead, dead, dead, dead, dead, live, live, dead, dead, dead, dead, dead, dead],
    [dead, dead, dead, dead, dead, dead, dead, dead, live, dead, dead, dead, dead, dead, dead],
    [dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead],
    [dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead],
    [dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead],
    [dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead],
    [dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead],
    [dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead, dead]
  ]).

glider(
  [ [dead, dead, dead, dead, dead],
    [dead, live, dead, dead, dead],
    [dead, dead, live, dead, dead],
    [live, live, live, dead, dead],
    [dead, dead, dead, dead, dead]
  ]).
     
blinker(
  [ [dead, dead, dead, dead, dead],
    [dead, dead, dead, dead, dead],
    [dead, live, live, live, dead],
    [dead, dead, dead, dead, dead],
    [dead, dead, dead, dead, dead]
  ]).

toad(
  [ [dead, dead, dead, dead, dead, dead],
    [dead, dead, dead, dead, dead, dead],
    [dead, dead, live, live, live, dead],
    [dead, live, live, live, dead, dead],
    [dead, dead, dead, dead, dead, dead],
    [dead, dead, dead, dead, dead, dead]
  ]).

spaceship(
  [ [dead, dead, dead, dead, dead, dead, dead, dead, dead],
    [dead, dead, dead, dead, dead, dead, dead, dead, dead],
    [dead, dead, live, dead, dead, live, dead, dead, dead],
    [dead, dead, dead, dead, dead, dead, live, dead, dead],
    [dead, dead, live, dead, dead, dead, live, dead, dead],
    [dead, dead, dead, live, live, live, live, dead, dead],
    [dead, dead, dead, dead, dead, dead, dead, dead, dead],
    [dead, dead, dead, dead, dead, dead, dead, dead, dead],
    [dead, dead, dead, dead, dead, dead, dead, dead, dead]
  ]).
