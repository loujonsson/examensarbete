%%%-------------------------------------------------------------------
%%% @author lou
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. Apr 2021 15:38
%%%-------------------------------------------------------------------
-module(outputFileProcessor).
-author("lou").

%% API
-export([receiveDone/0]).

receiveDone() -> io:format("received done.").