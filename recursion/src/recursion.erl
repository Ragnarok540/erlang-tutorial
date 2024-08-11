-module(recursion).
-export([fibonacci/1, factorial/1, avg/1]).

fibonacci(0) -> 0;
fibonacci(1) -> 1;
fibonacci(N) ->
    fibonacci(N - 1) + fibonacci(N - 2).

factorial(0) -> 1;
factorial(1) -> 1;
factorial(N) ->
    N * factorial(N - 1).

avg(L) ->
    sum(L) / length(L).

sum([]) -> 0;
sum([H|T]) ->
    H + sum(T).
