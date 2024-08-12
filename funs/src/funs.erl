-module(funs).
-export([greet/0, filter/0, map/0, greet2/0]).

greet() ->
    Greetings = fun(Name) -> io:format("Hello, ~s~n", [Name]) end,
    Greetings("Erlang").

filter() ->
    Filter = fun(X) -> X > 10 end,
    Scores = [100.0, 5.0, 9.0, 11.0, 99.0, 10.0],
    lists:filter(Filter, Scores).

map() ->
    Filter = fun(X) -> X > 10 end,
    Scores = [100.0, 5.0, 9.0, 11.0, 99.0, 10.0],
    lists:map(Filter, Scores).

greet2() ->
    Greetings = fun(Greeting) -> (fun(Name) -> io:format("~s, ~s~n", [Greeting, Name]) end) end,
    Hi = Greetings("Hi"),
    Hi("Elixir").
