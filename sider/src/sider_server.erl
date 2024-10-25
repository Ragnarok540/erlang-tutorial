-module(sider_server).
-export([start_server/0, stop_server/0]).

-record(entry, {key, value}).

initialize_db() ->
    mnesia:create_schema([node()]),
    mnesia:start(),
    mnesia:create_table(entry, [{attributes, record_info(fields, entry)}]).

start_server() ->
    initialize_db(),
    {ok, Listen} = gen_tcp:listen(10101, [binary, {packet, 4}, {reuseaddr, true}, {active, true}]),
    spawn(fun() -> par_connect(Listen) end).

par_connect(Listen) ->
    {ok, Socket} = gen_tcp:accept(Listen),
    spawn(fun() -> par_connect(Listen) end),
    loop(Socket).

stop_server() ->
    mnesia:stop().

loop(Socket) ->
    receive
        {tcp, Socket, Bin} ->
            io:format("Server received binary = ~p~n", [Bin]),
            Str = binary_to_term(Bin),
            Reply = process_command(Str),
            BinReply = term_to_binary(Reply),
            io:format("Server replying = ~s~n", [BinReply]),
            gen_tcp:send(Socket, BinReply),
            loop(Socket);
        {tcp_closed, Socket} -> io:format("Server socket closed ~n")            
    end.

process_command(Str) ->
    Parts = string:split(Str, " ", all),
    Command = lists:nth(1, Parts),
    case Command of
        "set" -> set_value(lists:nth(2, Parts), lists:nth(3, Parts));
        "get" -> get_value(lists:nth(2, Parts));
        "size" -> size();
        "keys" -> keys();
        "delete" -> delete(lists:nth(2, Parts));
        "exists" -> exists(lists:nth(2, Parts))
    end.

set_value(Key, Value) ->
    Entry = #entry{key=Key, value=Value},
    F = fun() ->
        mnesia:write(Entry)
    end,
    mnesia:transaction(F),
    {ok, Key, Value}.

get_value(Key) ->
    F = fun() ->
        Oid = {entry, Key},
        Entries = mnesia:read(Oid),
        case Entries =:= [] of
            true -> does_not_exist;
            false -> lists:nth(1, Entries)
        end
    end,
    mnesia:transaction(F).

size() ->
    F = fun() ->
        mnesia:table_info(entry, size)
    end,
    {ok, mnesia:transaction(F)}.

keys() ->
    F = fun() ->
        mnesia:all_keys(entry)
    end,
    {ok, mnesia:transaction(F)}.

delete(Key) ->
    Oid = {entry, Key},
    F = fun() ->
        mnesia:delete(Oid)
    end,
    mnesia:transaction(F),
    {ok, Key}.

exists(Key) ->
    Exists = get_value(Key),
    case Exists of
        {atomic, does_not_exist} -> false;
        {atomic, _} -> true
    end.
