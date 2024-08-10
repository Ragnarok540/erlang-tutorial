-module(length).
-export([convert_meters/1]).

-define(YARD, 1.0936).
-define(INCH, 39.370).
-define(FOOT, 3.28).

convert_meters({yard, Meters}) ->
    Meters * ?YARD;
convert_meters({inch, Meters}) ->
    Meters * ?INCH;
convert_meters({foot, Meters}) ->
    Meters * ?FOOT.
