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
  mnesia:start(),
  queryHandler:queryInit(),
  getQueryFromUser().
%receiveHeader(headList) ->
%    io:format(headList).

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
    off ->
      queryHandler:receiveValidCommand("done")
  end.

testCheckValidAttribute([Element]) ->
  case Element of
    "done" ->
      %queryHandler:receiveValidCommand("done"),
      off;
    _ -> false
  end;
testCheckValidAttribute(Tokens) ->
  Attribute=hd(Tokens),
  Number=list_to_integer(lists:last(Tokens)),
  case Attribute of
    "zipCode" ->
      lists:member(Number, lists:seq(0,99999));
    "gender" ->
      lists:member(Number, lists:seq(0,4));
    "ageGroup" ->
      lists:member(Number, lists:seq(0,3));
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