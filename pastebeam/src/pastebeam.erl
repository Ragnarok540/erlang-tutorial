-module(pastebeam).
-export([start/0, accepter/2, server/1]).

start() ->
    {ok, LSock} = gen_tcp:listen(6969, [binary, {packet, 0}, {reuseaddr, true}]),
    Sink = spawn(pastebeam, server, ["Hello"]),
    spawn(pastebeam, accepter, [LSock, Sink]),
    Sink.

server(Message) ->
    receive
        {connected, Sock} ->
            gen_tcp:send(Sock, ["----------------------------\n",
                                Message, "\n",
                                "----------------------------\n"]),
            gen_tcp:close(Sock),
            server(Message);
        {message, NewMessage} ->
            server(NewMessage)
    end.

accepter(LSock, Sink) ->
    {ok, Sock} = gen_tcp:accept(LSock),
    Sink ! {connected, Sock},
    accepter(LSock, Sink).
