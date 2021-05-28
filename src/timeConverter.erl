%%%-------------------------------------------------------------------
%%% @author ant
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. May 2021 13:30
%%%-------------------------------------------------------------------
-module(timeConverter).
-author("ant").

%% API
-export([timeInitiate/2]).

timeInitiate(StartTime,StopTime)->
  timeConverter(StartTime),
  timeConverter(StopTime).

timeConverter(Year,Month,Day,Hours,Minutes,Seconds) ->
  TimeInMs=(calendar:datetime_to_gregorian_seconds(
    {{Year,Month,Day},{Hours,Minutes,Seconds}}
  ) - 62167219200)*1000000,
  TimeInMs.
