-module(guards).
-export([range/1, sum_is_10_or_20/2]).

range(X) when is_integer(X), X > 10, X < 100 ->
    io:format("~w is in range~n", [X]);
range(X) ->
    io:format("~w is not in range~n", [X]).

sum_is_10_or_20(X, Y) when X + Y == 10; X + Y == 20 ->
    io:format("~w + ~w is 10 or 20 ~n", [X, Y]);
sum_is_10_or_20(X, Y) ->
    io:format("~w + ~w is not 10 or 20 ~n", [X, Y]).

% is_A(X) ->
%     X == "A".

% is_B(X) ->
%     X == "B".

% is_A_or_B(X) when is_A(X); is_B(X) ->
%     io:format("~w is in A or B~n", [X]);
% is_A_or_B(X) ->
%     io:format("~w is not A or B~n", [X]).
