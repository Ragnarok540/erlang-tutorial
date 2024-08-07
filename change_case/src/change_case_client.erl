-module(change_case_client).
-export([change_case/3]).

change_case(Server, Str, Command) ->
    Server ! {self(), {Str, Command}},
    receive
        {Server, ResultString} ->
            ResultString
    end.
