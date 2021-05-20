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
-export([testfile/1,benchmarkInput/0,benchmark/0,stdv/1,mean/1, sumPowerByTwo/2]).
%test1-3 are different tests of counting time
%not working - no list
testfile(Filename) ->
  Start = os:timestamp(),
  main:run(Filename),
  Time=timer:now_diff(os:timestamp(), Start) / 100000,
  Time.


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
loopclass(Function,Parameter,NumberOfLoops) ->
  ListOfValues=loopfunction(0, NumberOfLoops, Function,Parameter),
  [mean(ListOfValues),stdv(ListOfValues)].
benchmarkInput() ->
  io:format("start benchamrk input ~n"),
  Start = os:timestamp(),
  % io:format("avrage time for 1000 sample: ~f sek ~n",[average(loopfunction(0, 10, fun testfile/1,"input1000.txt"))]),
  % io:format("avrage time for 2000 sample: ~f sek ~n",[average(loopfunction(0, 10, fun testfile/1,"input2000.txt"))]),
  % io:format("avrage time for 3000 sample: ~f sek ~n",[average(loopfunction(0, 10, fun testfile/1,"input3000.txt"))]),
  % io:format("avrage time for 4000 sample: ~f sek ~n",[average(loopfunction(0, 10, fun testfile/1,"input4000.txt"))]),
  % io:format("avrage time for 5000 sample: ~f sek ~n",[average(loopfunction(0, 10, fun testfile/1,"input5000.txt"))]),
  % io:format("avrage time for 6000 sample: ~f sek ~n",[average(loopfunction(0, 10, fun testfile/1,"input6000.txt"))]),
  % io:format("avrage time for 7000 sample: ~f sek ~n",[average(loopfunction(0, 10, fun testfile/1,"input7000.txt"))]),
  % io:format("avrage time for 8000 sample: ~f sek ~n",[average(loopfunction(0, 10, fun testfile/1,"input8000.txt"))]),
  % io:format("avrage time for 9000 sample: ~f sek ~n",[average(loopfunction(0, 10, fun testfile/1,"input9000.txt"))]),
  % io:format("avrage time for 10000 sample: ~f sek~n",[average(loopfunction(0, 10, fun testfile/1,"input10000.txt"))]),
  % io:format("avrage time for 100000 sample: ~f sek~n",[average(loopfunction(0, 10, fun testfile/1,"input100000.txt"))]),

  io:format("1000: ~f writes per sek ~n",[1000/average(loopfunction(0, 100, fun testfile/1,"input1000.txt"))]),
  io:format("2000: ~f writes per sek ~n",[2000/average(loopfunction(0, 100, fun testfile/1,"input2000.txt"))]),
  io:format("3000: ~f writes per sek ~n",[3000/average(loopfunction(0, 100, fun testfile/1,"input3000.txt"))]),
  io:format("4000: ~f writes per sek ~n",[4000/average(loopfunction(0, 100, fun testfile/1,"input4000.txt"))]),
  io:format("5000: ~f writes per sek ~n",[5000/average(loopfunction(0, 100, fun testfile/1,"input5000.txt"))]),
  io:format("6000: ~f writes per sek ~n",[6000/average(loopfunction(0, 100, fun testfile/1,"input6000.txt"))]),
  io:format("7000: ~f writes per sek ~n",[7000/average(loopfunction(0, 100, fun testfile/1,"input7000.txt"))]),
  io:format("8000: ~f writes per sek ~n",[8000/average(loopfunction(0, 100, fun testfile/1,"input8000.txt"))]),
  io:format("9000: ~f writes per sek ~n",[9000/average(loopfunction(0, 100, fun testfile/1,"input9000.txt"))]),
  io:format("10000: ~f writes per sek ~n",[10000/average(loopfunction(0, 100, fun testfile/1,"input10000.txt"))]),
  io:format("100000: ~f writes per sek ~n",[100000/average(loopfunction(0, 100, fun testfile/1,"input100000.txt"))]),
  io:format("benchmark time:~f sek ~n",[timer:now_diff(os:timestamp(), Start) / 1000000]),
  io:format("done with benchmark~n").

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
  io:format("start benchmarkNumberValidator ~n"),
  io:format("avrage time for 55252:  ~f sek ~n",[mean(loopfunction(0, 1000, fun testCheckValidNumber2/1,"55252"))]),
  io:format("standart deviation:  ~f ~n",[stdv(loopfunction(0, 1000, fun testCheckValidNumber2/1,"55252"))]).