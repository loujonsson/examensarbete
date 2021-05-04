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
-export([mainStatictics/0,mainTimer/0,timeTaken/1,test/0,statsRun/1]).
mainTimer() ->
  Test = timer:tc(?MODULE, timeForDatabase,[]),
  io:format("timer:took this amount of time  ~p~n",[Test]).

timeTaken(Filename) ->
  Start = os:timestamp(),
  main:run(Filename),
  timer:now_diff(os:timestamp(), Start) / 1000.

mainStatictics() ->
  avgTime= timeTaken,
  io:format("average time for the run : ~n"),
  io:format(" ~p ~n",[avgTime]).

statsRun(Filename)->
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

test() ->
  io:format("avrage time for 1000 sample: ~f ~n",[average(loopfunction(0, 100, fun statsRun/1,"input1000.txt"))]),
  io:format("avrage time for 10000 sample: ~f ~n",[average(loopfunction(0, 100, fun statsRun/1,"input10000.txt"))]),
  io:format("avrage time for 100000 sample: ~f ~n",[average(loopfunction(0, 100, fun statsRun/1,"input100000.txt"))]),
  io:format("done with benchmark").
