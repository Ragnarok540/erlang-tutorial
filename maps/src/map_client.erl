-module(map_client).
-export([get/2, set/3, size/1, keys/1, delete/2, exists/2]).

get(Server, Key) ->
    Server ! {self(), {Key, get}},
    receive
        {Server, {ok, Value}} ->
            Value;
        {Server, error} ->
            error
    end.

set(Server, Key, Value) ->
    Server ! {self(), {Key, Value, set}},
    receive
        {Server, {ok, Key, Value}} ->
            ok
    end.

size(Server) ->
    Server ! {self(), {size}},
    receive
        {Server, {ok, Size}} ->
            Size
    end.

keys(Server) ->
    Server ! {self(), {keys}},
    receive
        {Server, {ok, Keys}} ->
            Keys
    end.

delete(Server, Key) ->
    Server ! {self(), {Key, delete}},
    receive
        {Server, {ok, Key}} ->
            Key
    end. 

exists(Server, Key) ->
    Server ! {self(), {Key, exists}},
    receive
        {Server, {ok, Exists}} ->
            Exists
    end. 
