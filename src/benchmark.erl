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
-export([testfileNonRelational/1,benchmarkInputNonRelational/0,benchmark/0,stdv/1,mean/1, sumPowerByTwo/2,benchmarkCustomeInput/2,bench/0,loopClassTime/1]).


testfileNonRelational(Filename) ->
  Start = os:timestamp(),
  main:run_nonrelational(Filename),
  Time=timer:now_diff(os:timestamp(), Start) / 100000,
  Time.
testfileRelational(Filename) ->
  Start = os:timestamp(),
  main:run_relational(Filename),
  Time=timer:now_diff(os:timestamp(), Start) / 100000,
  Time.



testInputNonRelational(String) ->
  fileProcessor_nonrelational:parse("reportingnode1,1538388005000,1538388000000,1,240,10,B9D2A6BD5FF6C73AFAB8064957D24F3AFB63F6181ED9A775E3786A29,240,10,3,12,12,12,10102,30211,102,30211,12,12,12,1,59.31683,18.0569,175,1,2,11010,12,CRLF2").

testInputRelational(String) ->
  fileProcessor_relational:parse("reportingnode1,1538388005000,1538388000000,1,240,10,B9D2A6BD5FF6C73AFAB8064957D24F3AFB63F6181ED9A775E3786A29,240,10,3,12,12,12,10102,30211,102,30211,12,12,12,1,59.31683,18.0569,175,1,2,11010,12,CRLF2").

testLou() ->
  db_relational:write_event("B9D2A6BD5FF6C73AFAB8064957D24F3A1063F6181ED9A775E3786A29","1538388005000","1","1538388005000","cell1", "reportingNode1","4", "240", "10", [], []),
  db_relational:write_event("B9D2A6BD5FF6C73AFAB8064957D24F3A1063F6181ED9A775E3786A30","1538388005001","1","1538388005000","cell1", "reportingNode1","4", "240", "10", [], []),
  db_relational:write_event("B9D2A6BD5FF6C73AFAB8064957D24F3A1063F6181ED9A775E3786A31","1538388005100","1","1538388005010","cell2", "reportingNode1","4", "240", "10", [], []).
  

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
  [average(ListOfValues),stdv(ListOfValues),Num/average(ListOfValues)].

loopClassTime(NumberRows) ->
  Start = os:timestamp(),
  loopfunction(0, NumberRows,fun testLou/1 ,1),
  Time=timer:now_diff(os:timestamp(), Start) / 100000,
  Time.


benchmarkInputNonRelational() ->
  io:format("start file benchmark non-relational~n"),
  Start = os:timestamp(),
  io:format("1000: avrage time ~f and standart deviation and ~f sek and ~f writespeed/s~n",loopClass(fun testfileNonRelational/1,"input1000.txt",10,1000)),
  io:format("2000: avrage time ~f and standart deviation and ~f sek and ~f writespeed/s ~n",loopClass(fun testfileNonRelational/1,"input2000.txt",10,2000)),
  io:format("3000: avrage time ~f and standart deviation and ~f sek and ~f writespeed/s ~n",loopClass(fun testfileNonRelational/1,"input3000.txt",10,3000)),
  io:format("4000: avrage time ~f and standart deviation and ~f sek and ~f writespeed/s ~n",loopClass(fun testfileNonRelational/1,"input4000.txt",10,4000)),
  io:format("5000: avrage time ~f and standart deviation and ~f sek and ~f writespeed/s ~n",loopClass(fun testfileNonRelational/1,"input5000.txt",10,5000)),
  io:format("6000: avrage time ~f and standart deviation and ~f sek and ~f writespeed/s ~n",loopClass(fun testfileNonRelational/1,"input6000.txt",10,6000)),
  io:format("7000: avrage time ~f and standart deviation and ~f sek and ~f writespeed/s ~n",loopClass(fun testfileNonRelational/1,"input7000.txt",10,7000)),
  io:format("8000: avrage time ~f and standart deviation and ~f sek and ~f writespeed/s ~n",loopClass(fun testfileNonRelational/1,"input8000.txt",10,8000)),
  io:format("9000: avrage time ~f and standart deviation and ~f sek and ~f writespeed/s ~n",loopClass(fun testfileNonRelational/1,"input9000.txt",10,9000)),
  io:format("10000: avrage time ~f and standart deviation and ~f sek and ~f writespeed/s ~n",loopClass(fun testfileNonRelational/1,"input10000.txt",10,10000)),
  io:format("100000: avrage time ~f and standart deviation and ~f sek and ~f writespeed/s ~n",loopClass(fun testfileNonRelational/1,"input100000.txt",10,100000)),
  io:format("benchmark time:~f sek ~n",[timer:now_diff(os:timestamp(), Start) / 1000000]),
  io:format("done with benchmark~n").
benchmarkInputRelational() ->
io:format("start file benchmark relational~n"),
Start = os:timestamp(),
io:format("1000: avrage time ~f and standart deviation and ~f sek and ~f writespeed/s~n",loopClass(fun testfileRelational/1,"input1000.txt",10,1000)),
io:format("2000: avrage time ~f and standart deviation and ~f sek and ~f writespeed/s ~n",loopClass(fun testfileRelational/1,"input2000.txt",10,2000)),
io:format("3000: avrage time ~f and standart deviation and ~f sek and ~f writespeed/s ~n",loopClass(fun testfileRelational/1,"input3000.txt",10,3000)),
io:format("4000: avrage time ~f and standart deviation and ~f sek and ~f writespeed/s ~n",loopClass(fun testfileRelational/1,"input4000.txt",10,4000)),
io:format("5000: avrage time ~f and standart deviation and ~f sek and ~f writespeed/s ~n",loopClass(fun testfileRelational/1,"input5000.txt",10,5000)),
io:format("6000: avrage time ~f and standart deviation and ~f sek and ~f writespeed/s ~n",loopClass(fun testfileRelational/1,"input6000.txt",10,6000)),
io:format("7000: avrage time ~f and standart deviation and ~f sek and ~f writespeed/s ~n",loopClass(fun testfileRelational/1,"input7000.txt",10,7000)),
io:format("8000: avrage time ~f and standart deviation and ~f sek and ~f writespeed/s ~n",loopClass(fun testfileRelational/1,"input8000.txt",10,8000)),
io:format("9000: avrage time ~f and standart deviation and ~f sek and ~f writespeed/s ~n",loopClass(fun testfileRelational/1,"input9000.txt",10,9000)),
io:format("10000: avrage time ~f and standart deviation and ~f sek and ~f writespeed/s ~n",loopClass(fun testfileRelational/1,"input10000.txt",10,10000)),
io:format("100000: avrage time ~f and standart deviation and ~f sek and ~f writespeed/s ~n",loopClass(fun testfileRelational/1,"input100000.txt",10,100000)),
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
  benchmarkInputNonRelational(),
  benchmarkInputRelational().
