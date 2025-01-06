-module(fruit).

-export([write_fruits/0]).

write_fruits() ->
    {ok, S} = file:open("fruit_count.txt", [write]),
    io:format(S, "~s~n", ["Mango 5"]),
    io:format(S, "~s~n", ["Olive 10"]),
    io:format(S, "~s~n", ["Watermelon 3"]).
