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
-export([test2/1,test3/1,bench/0,test1/1]).
%test1-3 are different tests of counting time
%not working - no list
test1(Filename) ->
  Test = timer:tc(?MODULE, main:run(Filename),[]),
  Test.

test2(Filename) ->
  Start = os:timestamp(),
  main:run(Filename),
  Time=timer:now_diff(os:timestamp(), Start) / 100000,
  Time.

test3(Filename)->
  statistics(runtime),
  main:run(Filename),
  {_,Time_Since_Last_Call} = statistics(runtime),
  Time_Since_Last_Call.


average(X) ->
  average(X, 0, 0).
average([H|T], Length, Sum) ->
  average(T, Length + 1, Sum + H);
average([], Length, Sum) ->
  Sum / Length.

loopfunction(End, End, F,Args) -> [F(Args)];
loopfunction(Start, End, F,Args) -> [F(Args)|loopfunction(Start+1, End, F,Args)].

% lägg till 1000, 4000, 8000
% köra flera runs
% hur mkt av tidfen är att läsa in oh cskriva ut? beräkningstid
bench() ->
  Start = os:timestamp(),
  io:format("avrage time for 1000 sample: ~f sek ~n",[average(loopfunction(0, 10, fun test2/1,"input1000.txt"))]),
  io:format("avrage time for 10000 sample: ~f sek~n",[average(loopfunction(0, 10, fun test2/1,"input10000.txt"))]),
  io:format("avrage time for 100000 sample: ~f sek~n",[average(loopfunction(0, 10, fun test2/1,"input100000.txt"))]),
  io:format("benchmark time:~f sek ~n",[timer:now_diff(os:timestamp(), Start) / 1000000]),
  io:format("done with benchmark").

