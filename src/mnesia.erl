%%%-------------------------------------------------------------------
%%% @author lou
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Apr 2021 14:57
%%%-------------------------------------------------------------------
-module(mnesia).
-author("lou").

%% API
-export([install/1, write/1]).
-include("main.hrl").

install(Nodes) ->
  ok = mnesia:create_schema(Nodes),
  application:start(mnesia),
  mnesia:create_table(event,
    [{attributes, record_info(fields, event)},
      {index, [#event.presencePointId]},
      {disc_copies, Nodes}]).

write(Event) -> mnesia:dirty_write(Event).

