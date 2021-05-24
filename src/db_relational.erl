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


% adds visited network info to db if imsi is valid
add_visited_network_info(imsi, vMcc, vMnc) ->
  F = fun() ->
    case mnesia:read({main_event, imsi}) =:= [] of
      true -> 
        {error, unknown_imsi};
      false ->
        mnesia:write(#visisted_network_info{imsi=imsi,
          vMcc=vMcc,
          vMnc=vMnc})
    end
  end,
  mnesia:activity(transaction, F).


% add home network info to db
add_home_network_info(imsi, hMcc, hMnc) ->
  F = fun() ->
    case mnesia:read({main_event, imsi}) =:= [] of
      true -> 
        {error, unknown_imsi};
      false ->
        mnesia:write(#home_network_info{imsi=imsi,
          hMcc=hMcc,
          hMnc=hMnc})
    end
  end,
  mnesia:activity(transaction, F).

% add node if imsi valid
add_node(imsi, reportingNode) ->
  F = fun() ->
    case mnesia:read({main_event, imsi}) =:= [] of
      true -> 
        {error, unknown_imsi};
      false ->
        mnesia:write(#node{imsi=imsi,
          reportingNode=reportingNode})
    end
  end,
  mnesia:activity(transaction, F).


% adds mobile device to db if imsi is valid
add_mobile_device(imsi, rat) ->
  F = fun() ->
    case mnesia:read({main_event, imsi}) =:= [] of
      true -> 
        {error, unknown_imsi};
      false ->
        mnesia:write(#mobile_device{imsi=imsi,
          rat=rat})
    end
  end,
  mnesia:activity(transaction, F).


% add cell to db
% event_id should be a tuple or list or something consisting of hashed imsi and reporting ts.
add_cell(imsi, reportingTs, cellName, cellPortionId, locationEstimateShape, locationEstimateLat, locationEstimateLon, locationEstimateRadius) ->
  F = fun() ->
    case mnesia:read({main_event, imsi}) =:= [] orelse 
         mnesia:read({main_event, reportingTs}) =:= [] of
      true -> 
        {error, unknown_event};
      false ->
        mnesia:write(#cell{imsi=imsi,
          reportingTs=reportingTs,
          cellName=cellName,
          cellPortionId=cellPortionId,
          locationEstimateShape=locationEstimateShape,
          locationEstimateLat=locationEstimateLat,
          locationEstimateLon=locationEstimateLon,
          locationEstimateRadius=locationEstimateRadius})
    end
  end,
  mnesia:activity(transaction, F).


add_radio_access_type(ratType, ratTypeId) ->
  F = fun() ->
    case mnesia:read({mobile_device, rat}) =:= [] of
      true -> 
        {error, rat};
      false ->
        mnesia:write(#radio_access_type{ratType=ratType,
          ratTypeId=ratTypeId})
    end
  end,
  mnesia:activity(transaction, F).

add_gsm(gsmLac, gsmCid, rat_id) ->
  F = fun() ->
    case mnesia:read({radio_access_type, ratTypeId}) =:= [] of
      true -> 
        {error, rat};
      false ->
        mnesia:write(#gsm{gsmLac=gsmLac,
          gsmCid=gsmCid,
          rat_id=rat_id})
    end
  end,
  mnesia:activity(transaction, F).


add_umts(umtsLac, umtsSac, umtsRncId, umtsCi, rat_id) ->
  F = fun() ->
    case mnesia:read({radio_access_type, ratTypeId}) =:= [] of
      true -> 
        {error, rat};
      false ->
        mnesia:write(#gsm{umtsLac=umtsLac,
          umtsSac=umtsSac,
          umtsRncId=umtsRncId,
          umtsCi=umtsCi,
          rat_id=rat_id})
    end
  end,
  mnesia:activity(transaction, F).


add_lte(lteEnodeBId, lteCi, rat_id) ->
  F = fun() ->
    case mnesia:read({radio_access_type, ratTypeId}) =:= [] of
      true -> 
        {error, rat};
      false ->
        mnesia:write(#gsm{lteEnodeBId=lteEnodeBId,
          lteCi=lteCi,
          rat_id=rat_id})
    end
  end,
  mnesia:activity(transaction, F).









