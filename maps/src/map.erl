-module(map).
-export([create_map/0, update_map/0, match_map/0]).

create_map() ->
    MapA = #{ "Adam" => 10, "John" => 22 },
    MapB = MapA#{ "Roger" => 30 },
    MapB.

update_map() ->
    MapA = #{ "Adam" => 10, "Sarah" => 15, "John" => 22 },
    MapB = MapA#{ "Sarah" := 30 },
    MapB.

match_map() ->
    MapB = create_map(),
    #{ "John" := Value } = MapB,
    Value.
