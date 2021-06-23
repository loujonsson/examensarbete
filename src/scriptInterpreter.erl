%%%-------------------------------------------------------------------
%%% @author ant
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Apr 2021 14:25
%%%-------------------------------------------------------------------
-module(scriptInterpreter).
-author("ant").

%% API
-export([initProgram/0,getQueryFromUser/0, checkValidNumber/3, checkValidNumber2/3
]).

-include("main.hrl").

%start_interpreter() ->
% receive header from file procesor file
%receiveHeader(headList).
% displayHeaderFile(),
% getQuaryFromUser(),
% call
% DbWithQuary().
% reset(),
% done(),
% exit(),

initProgram() ->
  queryHandler:queryInit(),
  queryHandler:attributesInit(),

  specifyCounterType(),

%receiveHeader(headList) ->
%    io:format(headList).

% använda tupler istället

% {attrbiute, zipCode}, matcha stärng mot atom

% user must specify if the wanted statistics should be total or unique
specifyCounterType() ->
  Input = io:get_line(io:format("Please specify wished statistics 'total' or 'unique':~n")),
  case Input of 
    "total" -> queryHandler:receiveValidCommand(total);
    "unique" -> queryHandler:receiveValidCommand(unique);
    _ -> specifyCounterType()
  end,

  getQueryFromUser().
  

getQueryFromUser() ->
  Input = io:get_line(io:format("Set values on attributes~n")),
  Tokens = string:tokens(Input, ";=\n."),
  Command = processTokens(Tokens),
  case testnumCheckValidAttribute(Command) of
    true ->
     io:format("valid input~n"),
     queryHandler:receiveQueryAttribute(Command),
     getQueryFromUser();
    false->
      io:format("invalid command~n"),
      getQueryFromUser();
    clear ->
      io:format("reset program~n"),
      queryHandler:receiveValidCommand(clear);
    clear ->
      io:format("set period~n"),
      periodSetup();
    done ->
      io:format("exit program"),
      queryHandler:receiveValidCommand(done)
  end.

processTokens(Tokens) ->
  case Tokens of
    [SingleCommand] -> [SingleCommand];
    [AttributeType, Attribute] -> {AttributeType, Attribute}
  end.

testCheckValidAttribute([Element]) ->
  case Element of
    "done" ->
      %queryHandler:receiveValidCommand("done"),
      done;
    "total" ->
      true;
    "unique" ->
      true;
    "clear" ->
      clear;
    _ -> false
  end;
testCheckValidAttribute({AttributeType, Attribute}) ->
  case AttributeType of
    "zipCode" ->
      lists:member(Attribute, lists:seq(10000,99999)); % improve
    "gender" ->
      lists:member(string:to_integer(Attribute), lists:seq(0,2));
    "ageGroup" ->
      lists:member(string:to_integer(Attribute), lists:seq(0,6));
    "hMcc" ->
      true;
    "hMnc" ->
      true;
    _ ->
      false
  end.

testnumCheckValidAttribute([Element]) ->
  case Element of
    "done" ->
      %queryHandler:receiveValidCommand("done"),
      done;
    "total" ->
      true;
    "unique" ->
      true;
    "clear" ->
      clear;
    "period" ->
      period;
    _ -> false
  end;
testnumCheckValidAttribute({AttributeType, Attribute}) ->
  case AttributeType of
    "zipCode" ->
      checkValidNumber(Attribute,9999,999999);% improve
    "gender" ->
      checkValidNumber(Attribute,0,2);
    "ageGroup" ->
      checkValidNumber(Attribute,0,2);
    _ ->
      false
  end.
checkValidNumber(Attribute,Min,Max) ->
  {Number, _} = string:to_integer(Attribute),
  if
    (Number >= Min andalso Number =< Max) -> true;
    true -> false
  end.

checkValidNumber2(Attribute,Min,Max) ->
lists:member(Attribute, lists:seq(Min,Max)).



periodSetup() ->
  % period for IMSIstat 1000-3000
  %start ={{Year,Month,Day},{Hours,Minutes,Seconds}
  %stop = {{Year,Month,Day},{Hours,Minutes,Seconds}
  startBreakPoint = io:get_line(io:format("Set start time for statistic break-point ~n")),
  stopBreakPoint = io:get_line(io:format("Set start time for statistic break-point ~n")),

  outputFilePeriodFrequency = io:get_line(io:format("Set Period Frequency ~n")),

  startInterval = io:get_line(io:format("Set start time for statistic break-point ~n")),
  stopInterval = io:get_line(io:format("Set start time for inter ~n")),




  % period for output freq = everey 5
  %period start 1001
  %period stop 2005
  %function new output + restart the freq.

  io:format("Statistics Break-point?"),
  io:format("Statistics Segment~n"),
  io:format("Output Frequency?~n"),
  io:format("Output Perio?~n").








%checkValidAttribute(Attribute) ->
%  checklist = string:tokens("zipCode,gender,ageGroup,done", ","),
%  case lists:member(Attribute,checklist) of
%    true -> valid_input;
%    false -> invalid_input
%  end.

%checkValidAttribute(Attribute) ->
% case re:run(file,Attribute ) of
%  match -> true;
% nomatch -> false;
%_ ->
% end.