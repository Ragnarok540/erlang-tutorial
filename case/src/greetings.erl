-module(greetings).
-export([greet/2, formal_greet/3]).

greet(Name, Language) ->
    case Language of
        polish -> io:format("Witaj, ~s~n", [Name]);
        english -> io:format("Hello, ~s~n", [Name]);
        spanish -> io:format("Hola, ~s~n", [Name])
    end.

formal_greet(Name, Language, Age) ->
    case Language of
        polish when Age < 18 -> io:format("Witaj, ~s~n", [Name]);
        polish -> io:format("Witaj, Panie ~s~n", [Name]);
        english when Age < 18 -> io:format("Hello, ~s~n", [Name]);
        english -> io:format("Hello, Mister ~s~n", [Name]);
        spanish when Age < 18 -> io:format("Hola, ~s~n", [Name]);
        spanish -> io:format("Hola, Señor ~s~n", [Name])
    end.
