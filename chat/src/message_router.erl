-module(message_router).

-define(SERVER, message_router).

-compile(export_all).

start() ->
    global:trans({?SERVER, ?SERVER},
                 fun() ->
                     case global:whereis_name(?SERVER) of
                         undefined ->
                             Pid = spawn(message_router, route_messages, [dict:new()]),
                             global:register_name(?SERVER, Pid);
                         _ ->
                             ok
                     end
                 end).

stop() ->
    global:trans({?SERVER, ?SERVER},
                 fun() ->
                     case global:whereis_name(?SERVER) of
                         undefined ->
                             ok;
                         _ ->
                             global:send(?SERVER, shutdown)
                     end
                 end).
    
send_chat_message(Addressee, MessageBody) ->
    global:send(?SERVER, {send_chat_msg, Addressee, MessageBody}).
    
register_client(ClientName, ClientPid) ->
    global:send(?SERVER, {register_client, ClientName, ClientPid}).  
     
unregister_client(ClientName) ->
    global:send(?SERVER, {unregister_client, ClientName}).

route_messages(Clients) ->
    receive
        {send_chat_msg, ClientName, MessageBody} ->
            case dict:find(ClientName, Clients) of
                {ok, ClientPid} ->
                    ClientPid ! {printmsg, MessageBody};
                error ->
                    io:format("Error! Unknown client: ~p~n", [ClientName])
            end,        
            route_messages(Clients);
        {register_client, ClientName, ClientPid} ->
            route_messages(dict:store(ClientName, ClientPid, Clients));
        {unregister_client, ClientName} ->
            case dict:find(ClientName, Clients) of
                {ok, ClientPid} ->
                    ClientPid ! stop,
                    route_messages(dict:erase(ClientName, Clients));
                error ->
                    io:format("Error! Unknown client: ~p~n", [ClientName]),
                    route_messages(Clients)
            end;
        shutdown ->
            io:format("Shutting down~n");
        Others ->
            io:format("Warning! Received: ~p~n", [Others]),
            route_messages(Clients)
    end.
