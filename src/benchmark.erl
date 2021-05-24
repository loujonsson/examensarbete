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
-export([testfile/1,benchmarkInput/0,benchmark/0,stdv/1,mean/1, sumPowerByTwo/2,test/0,benchmarkCustomeInput/1]).
%test1-3 are different tests of counting time
%not working - no list
testfile(Filename) ->
  Start = os:timestamp(),
  main:run(Filename),
  Time=timer:now_diff(os:timestamp(), Start) / 100000,
  Time.
testfilecustome(String) ->
  fileProcessor:parse(String).


testCheckValidNumber(Attribute) ->
  Start = os:timestamp(),
  scriptInterpreter:checkValidNumber(Attribute,9999,999999),
  Time=timer:now_diff(os:timestamp(), Start) / 100000,
  Time.
testCheckValidNumber2(Attribute) ->
  Start = os:timestamp(),
  scriptInterpreter:checkValidNumber2(Attribute,9999,999999),
  Time=timer:now_diff(os:timestamp(), Start) / 100000,
  Time.

average(X) ->
  average(X, 0, 0).
average([H|T], Length, Sum) ->
  average(T, Length + 1, Sum + H);
average([], Length, Sum) ->
  Sum / Length.

loopfunction(End, End, F,Args) -> [F(Args)];
loopfunction(Start, End, F,Args) -> [F(Args)|loopfunction(Start, End, F,Args)].






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
loopclass(Function,Parameter,NumberOfLoops,Num) ->
  ListOfValues=loopfunction(0, NumberOfLoops, Function,Parameter),
  [average(ListOfValues),stdv(ListOfValues),Num/average(ListOfValues)].





loopclasscustom(NumberRows) ->
  ListOfValues=loopfunction(0, NumberRows,fun loopclasscustom2/1,NumberRows),
  [average(ListOfValues),stdv(ListOfValues),NumberRows/average(ListOfValues)].

loopclasscustom2(NumberRows) ->
  Start = os:timestamp(),
  loopfunction(0, NumberRows, fun testfilecustome/1,"reportingnode1,1538388005000,1538388000000,1,240,10,10000000000000000000000000000000000000000000000000000000,240,10,3,12,12,12,10102,30211,102,30211,12,12,12,1,59.31683,18.0569,175,1,2,11010,12,CRLF"),
  Time=timer:now_diff(os:timestamp(), Start) / 100000,
  Time.


benchmarkInput() ->
  io:format("start benchamrk input ~n"),
  Start = os:timestamp(),
  io:format("1000: avrage time ~f and standart deviation and ~f sek and ~f writespeed/s~n",loopclass(fun testfile/1,"input1000.txt",100,1000)),
  io:format("2000: avrage time ~f and standart deviation and ~f sek and ~f writespeed ~n",loopclass(fun testfile/1,"input2000.txt",100,2000)),
  io:format("3000: avrage time ~f and standart deviation and ~f sek and ~f writespeed ~n",loopclass(fun testfile/1,"input3000.txt",100,3000)),
  io:format("4000: avrage time ~f and standart deviation and ~f sek and ~f writespeed ~n",loopclass(fun testfile/1,"input4000.txt",100,4000)),
  io:format("5000: avrage time ~f and standart deviation and ~f sek and ~f writespeed ~n",loopclass(fun testfile/1,"input5000.txt",100,5000)),
  io:format("6000: avrage time ~f and standart deviation and ~f sek and ~f writespeed ~n",loopclass(fun testfile/1,"input6000.txt",100,6000)),
  io:format("7000: avrage time ~f and standart deviation and ~f sek and ~f writespeed ~n",loopclass(fun testfile/1,"input7000.txt",100,7000)),
  io:format("8000: avrage time ~f and standart deviation and ~f sek and ~f writespeed ~n",loopclass(fun testfile/1,"input8000.txt",100,8000)),
  io:format("9000: avrage time ~f and standart deviation and ~f sek and ~f writespeed ~n",loopclass(fun testfile/1,"input9000.txt",100,9000)),
  io:format("10000: avrage time ~f and standart deviation and ~f sek and ~f writespeed ~n",loopclass(fun testfile/1,"input10000.txt",100,10000)),
  io:format("100000: avrage time ~f and standart deviation and ~f sek and ~f writespeed ~n",loopclass(fun testfile/1,"input100000.txt",100,100000)),
  io:format("benchmark time:~f sek ~n",[timer:now_diff(os:timestamp(), Start) / 1000000]),
  io:format("done with benchmark~n").


benchmarkCustomeInput(Numberofinputs) ->

  io:format("avrage time ~f and standart deviation and ~f sek and ~f writespeed/s~n",loopclasscustom(Numberofinputs)).



benchmark() ->
  test().
  %benchmarkNumberValidator(),
  %benchmarkNumberValidator2().
 % benchmarkInput(),

benchmarkNumberValidator() ->
  io:format("start benchmarkNumberValidator ~n"),
  Start = os:timestamp(),
  io:format("avrage time for 55252:  ~f sek ~n",[average(loopfunction(0, 100, fun testCheckValidNumber/1,"55252"))]),
  io:format("avrage time for 11010: ~f sek~n",[average(loopfunction(0, 100, fun testCheckValidNumber/1,"11010"))]),
  io:format("avrage time for 43346: ~f sek~n",[average(loopfunction(0, 100, fun testCheckValidNumber/1,"43346"))]),
  io:format("benchmark time:~f sek ~n",[timer:now_diff(os:timestamp(), Start) / 1000000]),
  io:format("done with benchmarkNumberValidator~n").
benchmarkNumberValidator2() ->
  io:format("start benchmarkNumberValidator2 ~n"),
  Start = os:timestamp(),
  io:format("avrage time for 55252:  ~f sek ~n",[average(loopfunction(0, 100, fun testCheckValidNumber2/1,"55252"))]),
  io:format("avrage time for 11010: ~f sek~n",[average(loopfunction(0, 100, fun testCheckValidNumber2/1,"11010"))]),
  io:format("avrage time for 43346: ~f sek~n",[average(loopfunction(0, 100, fun testCheckValidNumber2/1,"43346"))]),
  io:format("benchmark time:~f sek ~n",[timer:now_diff(os:timestamp(), Start) / 1000000]),
  io:format("done with benchmarkNumberValidator2~n").

test() ->
  This=1000,
  io:format("~p start benchmarkNumberValidator ~n",[This+1]).
  %io:format("standart deviation :~f and avrage time ~f sek ~n",loopclass(fun testCheckValidNumber2/1,"55252",100,100)).
