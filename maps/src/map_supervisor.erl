-module(map_supervisor).
-export([main/0]).

main() ->
    MapServer = map_server:start(),
    map_client:set(MapServer, "hello", "world"),
    map_client:set(MapServer, "key", "value"),
    Get = map_client:get(MapServer, "hello"),
    io:format("~p is the value~n", [Get]),
    Size = map_client:size(MapServer),
    io:format("~w is the size~n", [Size]),
    Keys = map_client:keys(MapServer),
    io:format("~p are the keys~n", [Keys]),
    Delete = map_client:delete(MapServer, "hello"),
    io:format("~p has been deleted~n", [Delete]),
    Exists = map_client:exists(MapServer, "hello"),
    io:format("'hello' is a key: ~p~n", [Exists]).
