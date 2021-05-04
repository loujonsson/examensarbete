%%%-------------------------------------------------------------------
%%% @author ant
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. May 2021 18:39
%%%-------------------------------------------------------------------
-module(benchmark).
-author("ant").

%% API
-export([mainStatictics/0,mainTimer/0,timeForDatabase/0]).
mainTimer() ->
  Test = timer:tc(?MODULE, timeForDatabase,[]),
  io:format("timer:took this amount of time  ~p~n",[Test]).
mainStatictics() ->
  statistics(runtime),
  timeForDatabase(),
  {_,Time_Since_Last_Call} = statistics(runtime),
  Time_In_Microsecounds=Time_Since_Last_Call*1000,
%  io:format(" ~p ~p ~n",["1000","10000","100000","1000000","10000000"]),
  io:format(" time for run was : ~n"),
  io:format(" ~p ~n",[Time_In_Microsecounds]).



timeForDatabase() ->
  %database read/write code hereh
  main:run("input1000.txt").



average(X) ->
  average(X, 0, 0).

average([H|T], Length, Sum) ->
  average(T, Length + 1, Sum + H);

average([], Length, Sum) ->
  Sum / Length.
