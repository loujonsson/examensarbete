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


-define(INTERVAL, 60000). % One minute

init(Args) ->
  % Start first timer
  MyRef = erlang:make_ref(),
{ok, TRef} = erlang:send_after(?INTERVAL, self(), {trigger, MyRef}).


% Trigger only when the reference in the trigger message is the same as in State
handle_info({trigger, MyRef}, State = #your_record{latest=MyRef}) ->
  % Do the action

  % Start next timer
  MyRef = erlang:make_ref(),
{ok, TRef} = erlang:send_after(?INTERVAL, self(), trigger),


% Ignore this trigger, it has been superceeded!
handle_info({trigger, _OldRef}, State) ->
  {ok, State}.

handle_info(reset, State = #your_record{timer=TRef}) ->
  % Cancel old timer
  erlang:cancel_timer(TRef),
  % Start next timer
  MyNewRef = erlang:make_ref(),
  {ok, NewTRef} = erlang:send_after(?INTERVAL, self(), trigger),
