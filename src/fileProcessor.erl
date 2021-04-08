%%%-------------------------------------------------------------------
%%% @author lou
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Apr 2021 17:02
%%%-------------------------------------------------------------------
-module(fileProcessor).
-author("lou").

%% API
-export([receiveFile/1]).

receiveFile(File) ->
  File, processHeader(File).


