%%%-------------------------------------------------------------------
%%% @author lou
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. May 2021 17:12
%%%-------------------------------------------------------------------
-module(db_relational).
-author("lou").

%% API
-export([install/1]).
-include("main.hrl").


install(Nodes) ->
  ok = mnesia:create_schema(Nodes),
  rpc:multicall(Nodes, application, start, [mnesia]),
  mnesia:create_table(anonymous_person,
    [{attributes, record_info(fields, anonymous_person)},
      {index, [#anonymous_person.hashedImsi]},
      {disc_copies, Nodes}]),

  mnesia:create_table(cell,
      [{attributes, record_info(fields, cell)},
      {index, [#cell.event_id]},
      {disc_copies, Nodes}]),

  mnesia:create_table(cell,
      [{attributes, record_info(fields, cell)},
      {index, [#cell.event_id]},
      {disc_copies, Nodes}]),  

  mnesia:create_table(visisted_network_info,
      [{attributes, record_info(fields, visisted_network_info)},
      {index, [#visisted_network_info.imsi]},
      {disc_copies, Nodes}]),    
    
   mnesia:create_table(home_network_info,
      [{attributes, record_info(fields, home_network_info)},
      {index, [#home_network_info.imsi]},
      {disc_copies, Nodes}]), 

   mnesia:create_table(mobile_device,
      [{attributes, record_info(fields, mobile_device)},
      {index, [#mobile_device.imsi]},
      {disc_copies, Nodes}]),  

   mnesia:create_table(node,
      [{attributes, record_info(fields, node)},
      {index, [#node.reportingNode]},
      {disc_copies, Nodes}]),  

   mnesia:create_table(main_event,
      [{attributes, record_info(fields, main_event)},
      {index, [#main_event.imsi, #main_event.reportingTs]},
      {disc_copies, Nodes}]),  

    mnesia:create_table(radio_access_type,
      [{attributes, record_info(fields, radio_access_type)},
      {index, [#radio_access_type.ratTypeId]},
      {disc_copies, Nodes}]), 

    mnesia:create_table(gsm,
      [{attributes, record_info(fields, gsm)},
      {index, [#gsm.rat_id]},
      {disc_copies, Nodes}]), 

    mnesia:create_table(umts,
      [{attributes, record_info(fields, umts)},
      {index, [#umts.rat_id]},
      {disc_copies, Nodes}]), 

    mnesia:create_table(lte,
      [{attributes, record_info(fields, lte)},
      {index, [#lte.rat_id]},
      {disc_copies, Nodes}]), 

    rpc:multicall(Nodes, application, stop, [mnesia]). % rpc allows mnesia action on all nodes.


% wait for at most 5 seconds until tables are available.
start(normal, []) ->
  mnesia:wait_for_tables([anonymous_person, cell, visited_network_info, home_network_info, mobile_device, node, main_event, radio_access_type, gsm, umts, lte], 5000).

stop(_) -> ok.


% adds event to the database. 
% maybe check if eventType = 1? No check yet.
add_event(hashedImsi, reportingTs, eventType) ->
  F = fun() ->
    mnesia:write(#main_event{imsi = hashedImsi, 
      reportingTs = reportingTs,
      eventType = eventType})
    end, 
  mnesia:activity(transaction, F). 

% adds an anonymous person if the hashed imsi is already in the database, otherwise returns error.
add_anonymous_person(imsi, gender, ageGroup, zipCode) ->
  F = fun() ->
    case mnesia:read({main_event, imsi}) =:= [] of
      true -> 
        {error, unknown_imsi};
      false ->
        mnesia:write(#anonymous_person{imsi=imsi,
          gender=gender,
          ageGroup=ageGroup,
          zipCode=zipCode})
    end
  end,
  mnesia:activity(transaction, F).














