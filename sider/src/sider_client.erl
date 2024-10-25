-module(sider_client).
-export([set/2, get/1, size/0, keys/0, delete/1, exists/1]).

eval(Str) ->
    {ok, Socket} = gen_tcp:connect("localhost", 10101, [binary, {packet, 4}]),
    Ok = gen_tcp:send(Socket, term_to_binary(Str)),
    receive
        {tcp, Socket, Bin} ->
            io:format("Client received binary = ~p~n", [Bin]),
            Val = binary_to_term(Bin),
            io:format("Client result = ~p~n", [Val]),
            gen_tcp:close(Socket)
    end.

set(Key, Value) ->
    Command = io_lib:format("set ~s ~s", [Key, Value]),
    eval(Command).

get(Key) ->
    Command = io_lib:format("get ~s", [Key]),
    eval(Command).

size() ->
    Command = "size",
    eval(Command).

keys() ->
    Command = "keys",
    eval(Command).

delete(Key) ->
    Command = io_lib:format("delete ~s", [Key]),
    eval(Command).

exists(Key) ->
    Command = io_lib:format("exists ~s", [Key]),
    eval(Command).
