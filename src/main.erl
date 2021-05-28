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
-export([run_nonrelational/1, run_relational/1]).

% take file as input, go through data and put in non-relational database
run_nonrelational(File) ->
  fileProcessor_nonrelational:receiveFile(File).

% take file as input, go through data and put in relational database
run_relational(File) ->
  fileProcessor_relational:receiveFile(File).
