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
-export([autoloopbenchmark/0,stdv/1,mean/1, sumPowerByTwo/2,benchmarkCustomeInput/2,loopClassTime/1,autoInputNonRelational/0,autoInputRelational/0,benchmarkFileNonRelational/1]).


benchmarkFileNonRelational(Filename) ->
  db_nonrelational:clearAllTables(),
  Start = os:timestamp(),
  main:run_nonrelational(Filename),
  Time=timer:now_diff(os:timestamp(), Start) / 1000000,
  Time.
benchmarkFileRelational(Filename) ->
  improved_db_relational:clearAllTables(),
  Start = os:timestamp(),
  main:run_relational(Filename),
  Time=timer:now_diff(os:timestamp(), Start) / 1000000,
  Time.



testInputNonRelational(String) ->
  fileProcessor_nonrelational:parse("reportingnode1,1538388005000,1538388000000,1,240,10,B9D2A6BD5FF6C73AFAB8064957D24F3AFB63F6181ED9A775E3786A29,240,10,3,12,12,12,10102,30211,102,30211,12,12,12,1,59.31683,18.0569,175,1,2,11010,12,CRLF2").

testInputRelational(String) ->
  fileProcessor_relational:parse("reportingnode1,1538388005000,1538388000000,1,240,10,B9D2A6BD5FF6C73AFAB8064957D24F3AFB63F6181ED9A775E3786A29,240,10,3,12,12,12,10102,30211,102,30211,12,12,12,1,59.31683,18.0569,175,1,2,11010,12,CRLF2").


average(X) ->
  average(X, 0, 0).
average([H|T], Length, Sum) ->
  average(T, Length + 1, Sum + H);
average([], Length, Sum) ->
  Sum / Length.

loopfunction(End, End, F,Args) -> [F(Args)];
loopfunction(Start, End, F,Args) -> [F(Args)|loopfunction(Start+1, End, F,Args)].

%stdv section
mean(NumberList) ->
  Sum = lists:foldl(fun(V, A) -> V + A end, 0, NumberList),
  Sum / length(NumberList).

sumPowerByTwo([], Mean) -> [];
sumPowerByTwo([H], Mean) -> (H-Mean)*(H-Mean);
sumPowerByTwo([H | T], Mean) -> (H-Mean)*(H-Mean) + sumPowerByTwo(T,Mean).

stdv(NumberList) ->
  N = length(NumberList),
  Mean = mean(NumberList),
  SumSquares=sumPowerByTwo(NumberList, Mean),
  math:sqrt((SumSquares)/(N)).
% lägg till 1000, 4000, 8000
% köra flera runs
% hur mkt av tidfen är att läsa in oh cskriva ut? beräkningstid
loopClass(Function,Parameter,NumberOfLoops,Num) ->
  ListOfValues=loopfunction(0, NumberOfLoops, Function,Parameter),
  [mean(ListOfValues),stdv(ListOfValues),Num/mean(ListOfValues)].
loopClassTime(NumberRows) ->
  Start = os:timestamp(),
  loopfunction(0, NumberRows,fun testInputRelational/1 ,1),
  Time=timer:now_diff(os:timestamp(), Start) / 1000,
  Time.

autoInputNonRelational() ->
  io:format("start file benchmark non-relational~n"),
  io:format("average time : standart deviation : rows per sec ~n"),
  Start = os:timestamp(),
  io:format("1000,~f,~f,~f~n",loopClass(fun benchmarkFileNonRelational/1,"realinput1000.txt",50,1000)),
  io:format("2000,~f,~f,~f~n",loopClass(fun benchmarkFileNonRelational/1,"realinput2000.txt",50,2000)),
  io:format("3000,~f,~f,~f ~n",loopClass(fun benchmarkFileNonRelational/1,"realinput3000.txt",50,3000)),
  io:format("4000,~f,~f,~f~n",loopClass(fun benchmarkFileNonRelational/1,"realinput4000.txt",50,4000)),
  io:format("5000,~f,~f,~f~n",loopClass(fun benchmarkFileNonRelational/1,"realinput5000.txt",50,5000)),
  io:format("6000,~f,~f,~f~n",loopClass(fun benchmarkFileNonRelational/1,"realinput6000.txt",50,6000)),
  io:format("7000,~f,~f,~f~n",loopClass(fun benchmarkFileNonRelational/1,"realinput7000.txt",50,7000)),
  io:format("8000,~f,~f,~f~n",loopClass(fun benchmarkFileNonRelational/1,"realinput8000.txt",50,8000)),
  io:format("9000,~f,~f,~f ~n",loopClass(fun benchmarkFileNonRelational/1,"realinput9000.txt",50,9000)),
  io:format("10000,~f,~f,~f~n",loopClass(fun benchmarkFileNonRelational/1,"realinput10000.txt",50,10000)),
  io:format("benchmark time:~f sek ~n",[timer:now_diff(os:timestamp(), Start) / 1000000]),
  io:format("done with benchmark~n").
autoInputRelational() ->
  io:format("start file benchmark relational~n"),
  io:format("average time : standart deviation : rows per sec ~n"),
  improved_db_relational:clearAllTables(),
  Start = os:timestamp(),
  io:format("1000,~f,~f,~f~n",loopClass(fun benchmarkFileRelational/1,"realinput1000.txt",50,1000)),
  io:format("2000,~f,~f,~f~n",loopClass(fun benchmarkFileRelational/1,"realinput2000.txt",50,2000)),
  io:format("3000,~f,~f,~f ~n",loopClass(fun benchmarkFileRelational/1,"realinput3000.txt",50,3000)),
  io:format("4000,~f,~f,~f~n",loopClass(fun benchmarkFileRelational/1,"realinput4000.txt",50,4000)),
  io:format("5000,~f,~f,~f~n",loopClass(fun benchmarkFileRelational/1,"realinput5000.txt",50,5000)),
  io:format("6000,~f,~f,~f~n",loopClass(fun benchmarkFileRelational/1,"realinput6000.txt",50,6000)),
  io:format("7000,~f,~f,~f~n",loopClass(fun benchmarkFileRelational/1,"realinput7000.txt",50,7000)),
  io:format("8000,~f,~f,~f~n",loopClass(fun benchmarkFileRelational/1,"realinput8000.txt",50,8000)),
  io:format("9000,~f,~f,~f ~n",loopClass(fun benchmarkFileRelational/1,"realinput9000.txt",50,9000)),
  io:format("10000,~f,~f,~f~n",loopClass(fun benchmarkFileRelational/1,"realinput10000.txt",50,10000)),

  io:format("benchmark time:~f sek ~n",[timer:now_diff(os:timestamp(), Start) / 1000000]),
  io:format("done with benchmark~n").


benchmarkCustomeInput(NumberOfRows,NumberOfTimes) ->
  io:format("~p,",[NumberOfRows]),
  io:format("~f,~f,~f ~n",loopClass(fun loopClassTime/1,NumberOfRows,NumberOfTimes,NumberOfRows)).

loop(1000) ->
  ok;
loop(Count) ->
  benchmarkCustomeInput(Count,10),
  loop(Count+1).




autoloopbenchmark() ->
  io:format("start benchamrk  ~n"),
  io:format("average time : standart deviation : writespeed/sec~n"),
  Start = os:timestamp(),
  loop(1),
  io:format("benchmark time:~f sek ~n",[timer:now_diff(os:timestamp(), Start) / 1000000]),
  io:format("done with benchmark~n").

