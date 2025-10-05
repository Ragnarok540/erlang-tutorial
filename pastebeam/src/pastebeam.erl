-module(pastebeam).
-export([start/0, accepter/1, session/2]).

start() ->
    {ok, LSock} = gen_tcp:listen(6969, [binary, {packet, 0}, {active, false}, {reuseaddr, true}]),
    Accepter = spawn(?MODULE, accepter, [LSock]),
    Accepter.

session(command, Sock) ->
    case gen_tcp:recv(Sock, 0) of
        {ok, <<"POST\r\n">>} ->
            session(post, Sock);
        {ok, <<"GET ", Id/binary>>} ->
            session({get, string:trim(Id)}, Sock);
        {ok, _} ->
            gen_tcp:send(Sock, "INVALID COMMAND\r\n"),
            gen_tcp:close(Sock),
            ok;
        {error, Reason} ->
            io:format("ERROR: session failed: ~w\n", [Reason]),
            gen_tcp:close(Sock),
            ok
    end;
session(post, Sock) ->
    io:format("POST MODE\n"),
    gen_tcp:close(Sock),
    ok;
session({get, Id}, Sock) ->
    io:format("GET MODE ~s\n", [Id]),
    gen_tcp:close(Sock),
    ok.

accepter(LSock) ->
    {ok, Sock} = gen_tcp:accept(LSock),
    spawn(?MODULE, session, [command, Sock]),
    accepter(LSock).
