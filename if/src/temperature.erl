-module(temperature).
-export([check_temperature/1]).

check_temperature(Temperature) ->
    if
        Temperature < 40 ->
            io:format("Temperature is ok~n");
        Temperature > 40 ->
            io:format("It's getting hot~n");
        true ->
            io:format("Any other case!~n")
    end.
