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
-export([start_interpreter/0,getQuaryFromUser/0,receiveHeader/1
]).

-include("main.hrl").

start_interpreter() ->
% receive header from file procesor file
receiveHeader(headList).
% displayHeaderFile(),
% getQuaryFromUser(),
% callDbWithQuary().
% reset(),
% done(),
% exit(),


receiveHeader(headList) ->
    io:format(headList).
% need to exeption if not = is added, and make done. work so that it jumps out of program
getQuaryFromUser() ->
  Input = io:get_line("Set values on attributes~n:"),
  Tokens = string:tokens(Input, ";=\n."),
  case testcheckValidAttribute(hd(Tokens),list_to_integer(lists:last(Tokens))) of
   true ->
      io:format("send data to database~n");
    false->
        io:format("invalid input~n")
  end,
    getQuaryFromUser().

testcheckValidAttribute(Attribute,Number) ->
  case Attribute of
    "zipCode" ->
      lists:member(Number, lists:seq(0,12));
    "gender" ->
      lists:member(Number, lists:seq(0,4));
    "ageGroup" ->
      lists:member(Number, lists:seq(0,3));
    "done" ->
      exit(done);
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