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
-export([]).
mainTimer() ->
  Test = timer:tc(?MODULE, timeForDatabase,[]),
  io:format("~p~n",[Test]),
  ok.
mainStatictics() ->
  statistics(runtime),
  timeForDatabase(),
  {_,Time_Since_Last_Call} = statistics(runtime),
  Time_In_Microsecounds=Time_Since_Last_Call*1000,
  io:format("~p~n",[Time_In_Microsecounds]),
  ok.
timeForDatabase() ->
  %database read/write code hereh
io:format("this is a test").
