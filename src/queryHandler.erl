%%%-------------------------------------------------------------------
%%% @author lou
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. Apr 2021 14:53
%%%-------------------------------------------------------------------
-module(queryHandler).
-author("lou").

%% API
-export([receiveValidCommand/1]).


receiveValidCommand(Input) ->
  Input,
  Tokens = string:tokens(Input, " "),
  Attribute = hd(Tokens).

getAttribute(Tokens) ->


