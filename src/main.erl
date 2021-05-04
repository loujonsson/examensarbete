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
-export([run/1]).

run(File) ->
  fileProcessor:receiveFile(File).
