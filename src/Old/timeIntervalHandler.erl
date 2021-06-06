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
-export([repeatedOutputFile/3]).

%will handle timer for intevall reapeat out put for the ouPutfile.
repeatedOutputFile(startTime,intervalTime,stopTime) ->
  erlang:send_after(intervalTime, main:run("input1000.txt")).

%will handle future call for sending outPutfile.
featureHandler(Time) ->
  io:format("test").