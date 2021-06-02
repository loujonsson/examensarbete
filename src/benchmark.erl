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
-export([testfileNonRelational/1,benchmarkInputNonRelational/0,benchmark/0,stdv/1,mean/1, sumPowerByTwo/2,benchmarkCustomeInput/2,bench/0,loopClassTime/1,benchmarkInputRelationalFakeData/0,benchmarkInputRelationalRealData/0,benchmarkInputNonRelationalFakeData/0,benchmarkInputNonRelationalRealData/0]).


testfileNonRelational(Filename) ->
  Start = os:timestamp(),
  main:run_nonrelational(Filename),
  Time=timer:now_diff(os:timestamp(), Start) / 1000000,
  Time.
testfileRelational(Filename) ->
  Start = os:timestamp(),
  main:run_relational(Filename),
  Time=timer:now_diff(os:timestamp(), Start) / 1000000,
  Time.



testInputNonRelational(String) ->
  fileProcessor_nonrelational:parse("reportingnode1,1538388005000,1538388000000,1,240,10,B9D2A6BD5FF6C73AFAB8064957D24F3AFB63F6181ED9A775E3786A29,240,10,3,12,12,12,10102,30211,102,30211,12,12,12,1,59.31683,18.0569,175,1,2,11010,12,CRLF2").

testInputRelational(String) ->
  fileProcessor_relational:parse("reportingnode1,1538388005000,1538388000000,1,240,10,B9D2A6BD5FF6C73AFAB8064957D24F3AFB63F6181ED9A775E3786A29,240,10,3,12,12,12,10102,30211,102,30211,12,12,12,1,59.31683,18.0569,175,1,2,11010,12,CRLF2").

testLou() ->
  db_relational:write_event("B9D2A6BD5FF6C73AFAB8064957D24F3A1063F6181ED9A775E3786A29","1538388005000","1","1538388005000","cell1", "reportingNode1","4", "240", "10", [], []).

  

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


benchmarkInputNonRelational() ->
  io:format("start file benchmark non-relational~n"),
  io:format("average time : standart deviation : Lines per sec ~n"),
  db_nonrelational:clearAllTables(),
  Start = os:timestamp(),
  io:format("1000,~f,~f,~f~n",loopClass(fun testfileNonRelational/1,"realinput1000.txt",100,1000)),
  db_nonrelational:clearAllTables(),
  io:format("2000,~f,~f,~f~n",loopClass(fun testfileNonRelational/1,"realinput2000.txt",100,2000)),
  db_nonrelational:clearAllTables(),
  io:format("3000,~f,~f,~f ~n",loopClass(fun testfileNonRelational/1,"realinput3000.txt",100,3000)),
  db_nonrelational:clearAllTables(),
  io:format("4000,~f,~f,~f~n",loopClass(fun testfileNonRelational/1,"realinput4000.txt",100,4000)),
  db_nonrelational:clearAllTables(),
  io:format("5000,~f,~f,~f~n",loopClass(fun testfileNonRelational/1,"realinput5000.txt",100,5000)),
  db_nonrelational:clearAllTables(),
  io:format("6000,~f,~f,~f~n",loopClass(fun testfileNonRelational/1,"realinput6000.txt",100,6000)),
  db_nonrelational:clearAllTables(),
  io:format("7000,~f,~f,~f~n",loopClass(fun testfileNonRelational/1,"realinput7000.txt",100,7000)),
  db_nonrelational:clearAllTables(),
  io:format("8000,~f,~f,~f~n",loopClass(fun testfileNonRelational/1,"realinput8000.txt",100,8000)),
  db_nonrelational:clearAllTables(),
  io:format("9000,~f,~f,~f ~n",loopClass(fun testfileNonRelational/1,"realinput9000.txt",100,9000)),
  db_nonrelational:clearAllTables(),
  io:format("10000,~f,~f,~f~n",loopClass(fun testfileNonRelational/1,"realinput10000.txt",100,10000)),
  db_nonrelational:clearAllTables(),
  io:format("benchmark time:~f sek ~n",[timer:now_diff(os:timestamp(), Start) / 1000000]),
  io:format("done with benchmark~n").

benchmarkInputNonRelationalFakeData() ->
  io:format("start file benchmark fake data non-relational~n"),
  Start = os:timestamp(),
  io:format("1000: avrage time ~f and standart deviation and ~f sek and ~f writespeed/s~n",loopClass(fun testfileNonRelational/1,"input1000.txt",100,1000)),
  io:format("benchmark time:~f sek ~n",[timer:now_diff(os:timestamp(), Start) / 1000000]),
  io:format("done with benchmark~n").
benchmarkInputNonRelationalRealData() ->
  io:format("start file benchmark real data non-relational~n"),
  Start = os:timestamp(),
  io:format("1000: avrage time ~f and standart deviation and ~f sek and ~f writespeed/s~n",loopClass(fun testfileNonRelational/1,"realinput1000.txt",100,1000)),
  io:format("benchmark time:~f sek ~n",[timer:now_diff(os:timestamp(), Start) / 1000000]),
  io:format("done with benchmark~n").

benchmarkInputRelationalRealData() ->
  io:format("start file benchmark non-relational~n"),
  io:format("average time : standart deviation : average time ~n"),
  improved_db_relational:clearAllTables(),
  Start = os:timestamp(),
  %io:format("1000,~f,~f,~f~n",loopClass(fun testfileRelational/1,"realinput1000.txt",3,1000)),
  %improved_db_relational:clearAllTables(),
  %io:format("2000,~f,~f,~f~n",loopClass(fun testfileRelational/1,"realinput2000.txt",3,2000)),
  %improved_db_relational:clearAllTables(),
  %io:format("3000,~f,~f,~f ~n",loopClass(fun testfileRelational/1,"realinput3000.txt",3,3000)),
  %improved_db_relational:clearAllTables(),
  %io:format("4000,~f,~f,~f~n",loopClass(fun testfileRelational/1,"realinput4000.txt",3,4000)),
  %improved_db_relational:clearAllTables(),
  %io:format("5000,~f,~f,~f~n",loopClass(fun testfileRelational/1,"realinput5000.txt",3,5000)),
  %improved_db_relational:clearAllTables(),
  %io:format("6000,~f,~f,~f~n",loopClass(fun testfileRelational/1,"realinput6000.txt",3,6000)),
  %improved_db_relational:clearAllTables(),
  %io:format("7000,~f,~f,~f~n",loopClass(fun testfileRelational/1,"realinput7000.txt",3,7000)),
  %improved_db_relational:clearAllTables(),
 % io:format("8000,~f,~f,~f~n",loopClass(fun testfileRelational/1,"realinput8000.txt",3,8000)),
  improved_db_relational:clearAllTables(),
  io:format("9000,~f,~f,~f ~n",loopClass(fun testfileRelational/1,"realinput9000.txt",3,9000)),
  improved_db_relational:clearAllTables(),
  io:format("10000,~f,~f,~f~n",loopClass(fun testfileRelational/1,"realinput10000.txt",3,10000)),
  improved_db_relational:clearAllTables(),
  io:format("benchmark time:~f sek ~n",[timer:now_diff(os:timestamp(), Start) / 1000000]),
  io:format("done with benchmark~n").

benchmarkInputRelationalFakeData() ->
  io:format("start file benchmark fake relational~n"),
  Start2 = os:timestamp(),
  io:format("1000: avrage time ~f and standart deviation and ~f sek and ~f writespeed/s~n",loopClass(fun testfileRelational/1,"input1000.txt",100,1000)),
  io:format("benchmark time:~f sek ~n",[timer:now_diff(os:timestamp(), Start2) / 1000000]),
  io:format("done with benchmark~n").


benchmarkCustomeInput(NumberOfRows,NumberOfTimes) ->
  io:format("~p,",[NumberOfRows]),
  io:format("~f,~f,~f ~n",loopClass(fun loopClassTime/1,NumberOfRows,NumberOfTimes,NumberOfRows)).

loop(1000) ->
  ok;
loop(Count) ->
  benchmarkCustomeInput(Count,10),
  loop(Count+1).




benchmark() ->
  io:format("start benchamrk  ~n"),
  io:format("average time : standart deviation : writespeed/sec~n"),
  Start = os:timestamp(),
  loop(1),
  io:format("benchmark time:~f sek ~n",[timer:now_diff(os:timestamp(), Start) / 1000000]),
  io:format("done with benchmark~n").

louBench(NumberOfRows)->
io:format("~p,",[NumberOfRows]),
io:format(": avrage time ~f and standart deviation and ~f sek and ~f writespeed/s~n",loopClass(fun loopClassTime/1,NumberOfRows,10,NumberOfRows*3)).




bench() ->
  io:format("This is a test").
