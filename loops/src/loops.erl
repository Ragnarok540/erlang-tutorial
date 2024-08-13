-module(loops).
-export([run_for/0, for/3, run_fordown/0, fordown/3, run_range/0, range/4]).

run_for() ->
    for(1, 10, fun(I) -> io:format("~w~n", [I]) end).

for(Max, Max, F) ->
    [F(Max)];
for(I, Max, F) ->
    [F(I)|for(I+1, Max, F)].

run_fordown() ->
    fordown(10, 1, fun(I) -> I end).

fordown(Min, Min, F) ->
    [F(Min)];
fordown(I, Min, F) ->
    [F(I)|fordown(I-1, Min, F)].

run_range() ->
    Step = fun(I) -> I + 2 end,
    range(0, 20, Step, fun(I) -> I end).

range(Max, Max, _, F) ->
    [F(Max)];
range(I, Max, Step, F) ->
    [F(I)|range(Step(I), Max, Step, F)].
