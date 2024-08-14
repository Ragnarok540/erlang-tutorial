-module(comp).
-export([start/0, start2/0, start3/0]).

start() ->
    Scores = [99, 45, 12, 56, 10],
    [X / 5 || X <- Scores].

start2() ->
    Scores = [{"Jerry", 99}, {"George", 45}, {"Elaine", 12}, {"Kramer", 56}, {"Larry", 10}],
    [{Name, Score > 12} || {Name, Score} <- Scores].

start3() ->
    Scores = [{"Jerry", 99}, {"George", 45}, {"Elaine", 12}, {"Kramer", 56}, {"Larry", 10}],
    [{"George", Score} || {"George", Score} <- Scores].
