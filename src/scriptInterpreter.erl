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
-export([initProgram/0,getQueryFromUser/0
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
  getQueryFromUser().
%receiveHeader(headList) ->
%    io:format(headList).

% använda tupler istället

% {attrbiute, zipCode}, matcha stärng mot atom

getQueryFromUser() ->
  Input = io:get_line(io:format("Set values on attributes~n")),
  Tokens = string:tokens(Input, ";=\n."),
  case testCheckValidAttribute(Tokens) of
    true ->
     io:format("valid input~n"),
     queryHandler:receiveValidCommand(Input),
     getQueryFromUser();
    false->
      io:format("invalid command~n"),
      getQueryFromUser();
    reset ->
      io:format("reset program ~n"),
      queryHandler:receiveValidCommand("reset");
    off ->
      io:format("exit program"),
      queryHandler:receiveValidCommand("done")
  end.

testCheckValidAttribute([Element]) ->
  case Element of
    "done" ->
      %queryHandler:receiveValidCommand("done"),
      off;
    "total" ->
      true;
    "unique" ->
      true;
    "reset" ->
      reset;
    _ -> false
  end;
testCheckValidAttribute(Tokens) ->
  Attribute=hd(Tokens), % definiera lista
  Number=list_to_integer(lists:last(Tokens)),
  case Attribute of
    "zipCode" ->
      lists:member(Number, lists:seq(10000,99999)); % improve
    "gender" ->
      lists:member(Number, lists:seq(0,2));
    "ageGroup" ->
      lists:member(Number, lists:seq(0,6));
    _ ->
      false
  end.


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