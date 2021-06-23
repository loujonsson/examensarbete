%%%-------------------------------------------------------------------
%%% @author lou
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. May 2021 10:32
%%%-------------------------------------------------------------------

-module(timeHandler).
-author("lou").

%% API
-export([getUniversalTimeNow/0, getNowTimeInUTC/0, convertTime/1]).


% returns the current time in milliseconds from 1970-01-01, UTC time.
getNowTimeInUTC() ->
    Now = getUniversalTimeNow(),
    convertTime(Now).


% time in 
getUniversalTimeNow() ->
    calendar:now_to_universal_time(erlang:timestamp()).


% converts time from specified year, month, day, hour, minute and seconds to milliseconds. 
convertTime({{Year,Month,Day},{Hours,Minutes,Seconds}} = SpecifiedTime) ->
  TimeInMs=(calendar:datetime_to_gregorian_seconds(
    SpecifiedTime
  ) - 62167219200)*1000,
  TimeInMs.

