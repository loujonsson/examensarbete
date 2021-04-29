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
-export([initProgram/0
]).

-include("main.hrl").

%start_interpreter() ->
% receive header from file procesor file
%receiveHeader(headList).
% displayHeaderFile(),
% getQuaryFromUser(),
% callDbWithQuary().
% reset(),
% done(),
% exit(),

initProgram() -> io:format("This is a test start of the program"),
  Test = queryHandler:queryInit(),
  io:format(Test),
  io:format("2n Hello"),
  getQueryFromUser().


%receiveHeader(headList) ->
%    io:format(headList).
% need to exeption if not = is added, and make done. work so that it jumps out of program
getQueryFromUser() ->
  Input = io:get_line("Set values on attributes~n:"),
  Tokens = string:tokens(Input, ";=\n."),
  case testCheckValidAttribute(hd(Tokens),list_to_integer(lists:last(Tokens))) of
   true ->
      queryHandler:receiveValidCommand(Input),
     getQueryFromUser();
    false->
      io:format("invalid command"),
      getQuaryFromUser();
    off ->
    io:format("powering off the program")

  end.


testCheckValidAttribute(Attribute,Number) ->
  case Attribute of
    "zipCode" ->
      lists:member(Number, lists:seq(0,99999));
    "gender" ->
      lists:member(Number, lists:seq(0,4));
    "ageGroup" ->
      lists:member(Number, lists:seq(0,3));
    "done" ->
      off;
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