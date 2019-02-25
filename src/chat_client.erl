-module(chat_client).

-compile(export_all).

register_client(ClientName) ->
    message_router:register_client(ClientName, fun(MessageBody) -> 
        chat_client:print_message(ClientName, MessageBody) end).

unregister_client(ClientName) ->
    message_router:unregister_client(ClientName).

send_message(Addressee, MessageBody) ->
    message_router:send_chat_message(Addressee, MessageBody).

print_message(ClientName, MessageBody) ->
    io:format("~p received: ~p~n", [ClientName, MessageBody]).

start_router() ->
    message_router:start().
