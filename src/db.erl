%%%-------------------------------------------------------------------
%%% @author lou
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. May 2021 17:12
%%%-------------------------------------------------------------------
-module(db).
-author("lou").

%% API
-export([install/1, start/2, stop/1, write/7, traverse_table_and_show/0, clearAllTables/0]).
-include("main.hrl").


install(Nodes) ->
  ok = mnesia:create_schema(Nodes),
  %timer:sleep(1000),
  %rpc:multicall(Nodes, application, start, [mnesia]),
  application:start(mnesia),

  mnesia:create_table(lou_event,
    [{attributes, record_info(fields, lou_event)},
      %{index, [#sim_card_information.hashedImsi]},
      {disc_copies, Nodes}]).

% wait for at most 5 seconds until tables are available.
start(normal, []) ->
  %mnesia:wait_for_tables([anonymous_person, cell, visited_network_info, home_network_info, mobile_device, node, main_event, radio_access_type, gsm, umts, lte], 5000).
  mnesia:wait_for_tables([lou_event], 5000).


stop(_) -> ok.


% adds relational event to the database. 
% TODO: maybe check if eventType = 1? No check yet.
write(ReportingNode,ReportingTs,EventTs,EventType,HMcc,HMnc, HashedImsi) ->
  F = fun() ->
    mnesia:write(#lou_event{
        hashedImsi=HashedImsi,
        reportingTs=ReportingTs,
      reportingNode=ReportingNode,
    
      eventTs=EventTs,
      eventType=EventType,
      hMcc=HMcc,
      hMnc=HMnc
      
    })
    
    end, 
  mnesia:activity(transaction, F). 


% clears all data in all tables in the relational database.
clearAllTables()->
  mnesia:clear_table(lou_event).

traverse_table_and_show()->
  Iterator =  fun(Rec,_)->
    io:format("~p~n",[Rec]),
    []
              end,
  case mnesia:is_transaction() of
    true -> mnesia:foldl(Iterator,[],lou_event);
    false ->
      Exec = fun({Fun,Tab}) -> mnesia:foldl(Fun, [],Tab) end,
      mnesia:activity(transaction,Exec,[{Iterator,lou_event}],mnesia_frag)
  end.

