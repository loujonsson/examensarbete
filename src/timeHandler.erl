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
-export([getUniversalTimeNow/0, getNowTimeInUTC/0]).


% returns the current time in milliseconds from 1970-01-01, UTC time.
getNowTimeInUTC() ->
    Now = getUniversalTimeNow(),
    timeConverter(Now).


% time in 
getUniversalTimeNow() ->
    calendar:now_to_universal_time(erlang:timestamp()).


% converts time from specified year, month, day, hour, minute and seconds to milliseconds. 
timeConverter({{Year,Month,Day},{Hours,Minutes,Seconds}} = SpecifiedTime) ->
  TimeInMs=(calendar:datetime_to_gregorian_seconds(
    SpecifiedTime
  ) - 62167219200)*1000000,
  TimeInMs.


% period for IMSIstat 1000-3000
%start ={{Year,Month,Day},{Hours,Minutes,Seconds}
%stop = {{Year,Month,Day},{Hours,Minutes,Seconds}
periodHandler()->
startBreakPoint = io:get_line(io:format("Set start time for statistic break-point ~n")),
stopBreakPoint = io:get_line(io:format("Set stop time for statistic break-point ~n")),
outputFilePeriodFrequency = io:get_line(io:format("Set Period Frequency ~n")),
startInterval = io:get_line(io:format("Set start time for interval~n")),
stopInterval = io:get_line(io:format("Set stop time for interval ~n")),
if (stopInterval > stopBreakPoint) ->
io:format("stop inteval is out of breakpoint"),
periodHandler();
true -> continue
end.


init([]) ->
  Timer = erlang:send_after(0, self(), check),
  {ok, Timer}.

handle_info(check, OldTimer) ->
  erlang:cancel_timer(OldTimer),
  Timer = erlang:send_after(10, self(), check),
  do_task(), % A function that executes your task
  {noreply, Timer}.


Timer = erlang:send_after(outputFilePeriodFrequency, self(), check),
{ok, Timer}.


% period for output freq = everey 5
%period start 1001
%period stop 2005
%function new output + restart the freq.
