%%%-------------------------------------------------------------------
%%% @author lou
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Apr 2021 17:00
%%%-------------------------------------------------------------------
-module(main).
-author("lou").

%% API
-export([nonrelational_run/1, relational_run/1]).

% take file as input, go through data and put in non-relational database
nonrelational_run(File) ->
  fileProcessor:receiveFile(File).

% take file as input, go through data and put in relational database
relational_run(File) ->
  fileProcessor_relational:receiveFile(File).
