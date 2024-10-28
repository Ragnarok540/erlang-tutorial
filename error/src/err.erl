-module(err).
-export([divide/2, calculate/2, search_one/2, search/2]).

divide(A, B) when B == 0 ->
    error({divideByZero, A});
divide(A, B) ->
    A / B.

calculate(A, B) ->
    try divide(A, B) of
        Val -> {{A, B}, normal, Val}
    catch
        error:{divideByZero, _X} -> {divideByZero, error, {A, B}}
    after
        io:format("cleanup goes here~n")
    end.

search_one(Element, List) ->
    Result = lists:filter(fun(X) -> X == Element end, List),
    if
        length(Result) == 0 -> throw({notFound, Element});
        length(Result) > 1 -> throw({notUnique, Element});
        true -> lists:nth(1, Result)
    end.

search(Element, List) ->
    try search_one(Element, List) of
        Val -> {ok, Val}
    catch
        throw:{notFound, Element} -> notFound;
        throw:{notUnique, Element} -> notUnique
    end.
