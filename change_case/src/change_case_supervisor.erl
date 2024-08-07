-module(change_case_supervisor).
-export([main/0]).

main() ->
    ChangeCaseServer = change_case_server:start(),
    First = change_case_client:change_case(ChangeCaseServer, "hello", uppercase),
    Last = change_case_client:change_case(ChangeCaseServer, "HELLO", lowercase),
    First ++ " " ++ Last.
