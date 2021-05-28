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
-export([timeInitiate/1,timeConverter/1]).

timeInitiate(Time)->
io:foramt("this is a test :)").
timeConverter({Attribute,Year,Month,Day,Hours,Minutes,Seconds}) ->
  TimeInMs=(calendar:datetime_to_gregorian_seconds(
    {{Year,Month,Day},{Hours,Minutes,Seconds}}
  ) - 62167219200)*1000000,
  %send to database(Attribute,TimeInMs)
  TimeInMs.
