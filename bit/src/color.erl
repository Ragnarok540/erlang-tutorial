-module(color).

-export([start/0]).

start() ->
    Color = 16#F09A29,
    io:format("Color: ~w~n", [Color]),
    Pixel = <<Color:24>>,
    io:format("Pixel: ~w~n", [Pixel]).
