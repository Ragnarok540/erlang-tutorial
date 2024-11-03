-module(palindrome).
-export([is_palindrome/1]).
-import(string, [slice/3]).

first(String) ->
    slice(String, 0, 1).

last(String) ->
    slice(String, length(String) - 1, 1).

middle(String) ->
    slice(String, 1, length(String) - 2).

comp_first_and_last(String) ->
    first(String) == last(String).

is_palindrome(Input) when length(Input) < 2 ->
    true;
is_palindrome(Input) when length(Input) == 2 ->
    comp_first_and_last(Input);
is_palindrome(Input) ->
    comp_first_and_last(Input) and is_palindrome(middle(Input)).
