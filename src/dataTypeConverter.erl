%%%-------------------------------------------------------------------
%%% @author lou
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. May 2021 11:11
%%%-------------------------------------------------------------------

-module(dataTypeConverter).
-author("lou").

%% API
-export([integer_to_string/1]).

% Converts number (int) to a string representation
integer_to_string(Number) ->
  lists:flatten(io_lib:format("~p", [Number])).

