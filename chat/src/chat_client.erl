-module(chat_client).
-compile(export_all).

register_client(ClientName) ->
    Pid = spawn(chat_client, handle_messages, [ClientName]),
    message_router:register_client(ClientName, Pid).

unregister_client(ClientName) ->
    message_router:unregister_client(ClientName).

send_message(Addressee, MessageBody) ->
    message_router:send_chat_message(Addressee, MessageBody).

handle_messages(ClientName) ->
    receive
        {printmsg, MessageBody} ->
            io:format("~p received: ~p~n", [ClientName, MessageBody]),
            handle_messages(ClientName);
        stop ->
            ok
    end.
        
start_router() ->
    message_router:start().
