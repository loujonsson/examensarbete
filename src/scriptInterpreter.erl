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
-export([getQuaryFromUser/0, receiveHeader/1]).
-include("main.hrl").

%start_interpreter() ->
% receive header from file procesor file
receiveHeader(Tokens) ->
  %Tokens, getQuaryFromUser(Tokens).
% displayHeaderFile(),
% getQuaryFromUser(),
% callDbWithQuary().
% reset(),
% done(),
% exit(),




getQuaryFromUser()->
  %how input from user should look like
  %
  %List = [_,_,table_name],
  Event = list_to_atom(string:strip(io:get_line("type input:"), right, $\n)),
  %test
  [test1,test2,test3]=string:tokens(Event, ";"),

  io:format("\n"),
  io:format(test1),
  io:format("\n"),
  io:format("\n"),
  io:format(test2),
  io:format("\n"),
  io:format("\n"),
  io:format(test3),
  io:format("\n").
%db:traverse_table_and_show(test1).