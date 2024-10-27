-module(conway).
-export([demo_grid/0, run_simulation/2]).

-record(grid, {height=10, width=10, rows}).
-record(transition, {y, x, state}).

mod(X, Y) when X > 0 -> X rem Y;
mod(X, Y) when X < 0 -> Y + X rem Y;
mod(0, _Y) -> 0.

new(Height, Width) ->
    Column = array:new(Height),
    Array2D = array:map(fun(_X, _T) -> array:new([{size, Width}, {fixed, true}, {default, empty}]) end, Column),
    #grid{height=Height, width=Width, rows=Array2D}.

query(Grid, Y, X) ->
    Row = array:get(mod(Y, Grid#grid.height), Grid#grid.rows),
    array:get(mod(X, Grid#grid.width), Row).

assign(Grid, Y, X, State) ->
    Row =  array:get(mod(Y, Grid#grid.height), Grid#grid.rows),
    UpdatedRow = array:set(mod(X, Grid#grid.width), State, Row),
    Rows = array:set(mod(Y, Grid#grid.height), UpdatedRow, Grid#grid.rows),
    Grid#grid{rows=Rows}.

draw(Value) ->
    case Value of
        empty -> "-";
        alive -> "*"
    end.

count_neighbors(Grid, Y, X) ->
    N  = query(Grid, Y + 1, X    ),
    NE = query(Grid, Y + 1, X + 1),
    E  = query(Grid, Y    , X + 1),
    SE = query(Grid, Y - 1, X + 1),
    S  = query(Grid, Y - 1, X    ),
    SW = query(Grid, Y - 1, X - 1),
    W  = query(Grid, Y    , X - 1),
    NW = query(Grid, Y + 1, X - 1),
    NeighborStates = [N, NE, E, SE, S, SW, W, NW],
    length(lists:filter(fun(State) -> State == alive end, NeighborStates)).

game_logic(State, Neighbors) ->
    case State of
        alive -> if
            Neighbors < 2 -> empty;
            Neighbors > 3 -> empty;
            true -> State end;
        empty -> if
            Neighbors == 3 -> alive;
            true -> State end
    end.

step_cell(Grid, Y, X) ->
    State = query(Grid, Y, X),
    Neighbors = count_neighbors(Grid, Y, X),
    NextState = game_logic(State, Neighbors),
    #transition{y=Y, x=X, state=NextState}.

simulate(Grid) ->
    Rows = array:map(fun(Y, Row) ->
        array:map(fun(X, _CellValue) ->
            Transition = step_cell(Grid, Y, X),
            Transition#transition.state end, Row) end, Grid#grid.rows),
    Grid#grid{rows=Rows}.

print(Grid) ->
    ColumnIndex = lists:seq(0, Grid#grid.width - 1),
    RowIndex = lists:seq(0, Grid#grid.height - 1),
    lists:foreach(fun(Y) ->
        io:format("|"),
        lists:foreach(fun(X) ->
            io:format(" ~s |", [draw(query(Grid, Y, X))]) end, ColumnIndex),
            io:format("~n") end, RowIndex).

demo_grid() ->
    Grid0 = new(10, 20),
    Grid1 = assign(Grid0, 0, 3, alive),
    Grid2 = assign(Grid1, 1, 4, alive),
    Grid3 = assign(Grid2, 2, 2, alive),
    Grid4 = assign(Grid3, 2, 3, alive),
    assign(Grid4, 2, 4, alive).

clear_screen() ->
    io:format("\ec").

end_simulation() ->
    io:format("~nEnd of simulation~n").

run_simulation(Grid, N) ->
    clear_screen(),
    UpdatedGrid = simulate(Grid),
    print(UpdatedGrid),
    timer:sleep(500),
    case N > 0 of
        true -> run_simulation(UpdatedGrid, N - 1);
        false -> end_simulation()
    end.
