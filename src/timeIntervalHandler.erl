%%%-------------------------------------------------------------------
%%% @author ant
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. May 2021 16:13
%%%-------------------------------------------------------------------
-module(timeIntervalHandler).
-author("ant").

%% API
-export([timeHandler/1]).


timeHandler(Time) ->
  erlang:send_after(Time, main:run("input1000.txt")),
  timeHandler(Time).


