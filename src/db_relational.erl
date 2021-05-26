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
-export([install/1, start/2, stop/1, fetchLastEvent/0, write_event/11, write_sim_card_information/6, write_cell/6, write_radio_access_type/2, write_gsm/3, write_umts/5, write_lte/3]).
-include("main.hrl").


install(Nodes) ->
  ok = mnesia:create_schema(Nodes),
  timer:sleep(1000),
  rpc:multicall(Nodes, application, start, [mnesia]),
  %application:start(mnesia),

  mnesia:create_table(sim_card_information,
    [{attributes, record_info(fields, sim_card_information)},
      {index, [#sim_card_information.hashedImsi]},
      {disc_copies, Nodes}]),

  mnesia:create_table(cell,
      [{attributes, record_info(fields, cell)},
      {index, [#cell.cellName]},
      {disc_copies, Nodes}]),
  
   mnesia:create_table(relational_event,
      [{attributes, record_info(fields, relational_event)},
      {index, [#relational_event.hashedImsi, #relational_event.reportingTs]},
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
      {disc_copies, Nodes}]).

    %rpc:multicall(Nodes, application, stop, [mnesia]). % rpc allows mnesia action on all nodes.


% wait for at most 5 seconds until tables are available.
start(normal, []) ->
  %mnesia:wait_for_tables([anonymous_person, cell, visited_network_info, home_network_info, mobile_device, node, main_event, radio_access_type, gsm, umts, lte], 5000).
  mnesia:wait_for_tables([sim_card_information, cell, relational_event, radio_access_type, gsm, umts, lte], 5000).


stop(_) -> ok.


% adds relational event to the database. 
% TODO: maybe check if eventType = 1? No check yet.
write_event(HashedImsi, ReportingTs,EventTs, EventType, CellName, ReportingNode, Rat, VMcc, VMnc,GroupPresencePointId,PresencePointId) ->
  F = fun() ->
    mnesia:write(#relational_event{hashedImsi=HashedImsi, 
      reportingTs=ReportingTs,
      eventTs=EventTs,
      eventType=EventType,
      cellName=CellName,
      reportingNode=ReportingNode,
      ratTypeId=Rat,
      vMcc=VMcc,
      vMnc=VMnc,
      groupPresencePointId=GroupPresencePointId,
      presencePointId=PresencePointId})
    end, 
  mnesia:activity(transaction, F). 

% fetch last rat id
fetchLastEvent() -> 
  F = fun() ->
    case mnesia:last(relational_event) of
      '$end_of_table' -> 1;
      _ -> fetchRatId(mnesia:last(relational_event))
    end
  end,
  mnesia:activity(transaction, F).

  fetchRatId(Event) ->
    Event#relational_event.ratTypeId+1.
  

% adds an anonymous person if the hashed imsi is already in the database, otherwise returns error.
write_sim_card_information(HashedImsi, Gender, AgeGroup, ZipCode, HMcc, HMnc) ->
  F = fun() ->
    case mnesia:read({relational_event, imsi}) =:= [] of
      true -> 
        {error, unknown_imsi};
      false ->
        mnesia:write(#sim_card_information{hashedImsi=HashedImsi,
          gender=Gender,
          ageGroup=AgeGroup,
          zipCode=ZipCode,
          hMcc=HMcc,
          hMnc=HMnc})
    end
  end,
  mnesia:activity(transaction, F).


% adds visited network info to db if imsi is valid
%add_visited_network_info(imsi, vMcc, vMnc) ->
%  F = fun() ->
%    case mnesia:read({main_event, imsi}) =:= [] of
%      true -> 
%        {error, unknown_imsi};
%      false ->
%        mnesia:write(#visisted_network_info{imsi=imsi,
%          vMcc=vMcc,
%          vMnc=vMnc})
%    end
%  end,
%  mnesia:activity(transaction, F).


% add home network info to db
%add_home_network_info(imsi, hMcc, hMnc) ->
%  F = fun() ->
%    case mnesia:read({main_event, imsi}) =:= [] of
%      true -> 
%        {error, unknown_imsi};
%      false ->
%        mnesia:write(#home_network_info{imsi=imsi,
%          hMcc=hMcc,
%          hMnc=hMnc})
%    end
%  end,
%  mnesia:activity(transaction, F).

% add node if imsi valid
%add_node(imsi, reportingNode) ->
%  F = fun() ->
%    case mnesia:read({main_event, imsi}) =:= [] of
%      true -> 
%        {error, unknown_imsi};
%      false ->
%        mnesia:write(#node{imsi=imsi,
%          reportingNode=reportingNode})
%    end
%  end,
%  mnesia:activity(transaction, F).


% adds mobile device to db if imsi is valid
%add_mobile_device(imsi, rat) ->
%  F = fun() ->
%    case mnesia:read({main_event, imsi}) =:= [] of
%      true -> 
%        {error, unknown_imsi};
%      false ->
%        mnesia:write(#mobile_device{imsi=imsi,
%          rat=rat})
%    end
%  end,
%  mnesia:activity(transaction, F).


% add cell to db
% event_id should be a tuple or list or something consisting of hashed imsi and reporting ts.
write_cell(CellName, CellPortionId, LocationEstimateShape, LocationEstimateLat, LocationEstimateLon, LocationEstimateRadius) ->
  F = fun() ->
    case mnesia:read({relational_event, imsi}) =:= [] of
      true -> 
        {error, unknown_event};
      false ->
        mnesia:write(#cell{cellName=CellName,
          cellPortionId=CellPortionId,
          locationEstimateShape=LocationEstimateShape,
          locationEstimateLat=LocationEstimateLat,
          locationEstimateLon=LocationEstimateLon,
          locationEstimateRadius=LocationEstimateRadius})
    end
  end,
  mnesia:activity(transaction, F).

% add radio raccess type record to database without id, but generating id inside function scope
write_radio_access_type(RatType,RatTypeId) ->
  F = fun() ->
    case mnesia:read({relational_event, rat}) =:= [] of
      true -> 
        {error, rat};
      false ->
        mnesia:write(#radio_access_type{ratType=RatType,
          ratTypeId=RatTypeId})
    end
  end,
  mnesia:activity(transaction, F).

% add gsm info to database
write_gsm(GsmLac, GsmCid, Rat_id) ->
  F = fun() ->
    case mnesia:read({radio_access_type, ratTypeId}) =:= [] of
      true -> 
        {error, rat};
      false ->
        mnesia:write(#gsm{gsmLac=GsmLac,
          gsmCid=GsmCid,
          rat_id=Rat_id})
    end
  end,
  mnesia:activity(transaction, F).


write_umts(UmtsLac, UmtsSac, UmtsRncId, UmtsCi, Rat_id) ->
  F = fun() ->
    case mnesia:read({radio_access_type, ratTypeId}) =:= [] of
      true -> 
        {error, rat};
      false ->
        mnesia:write(#umts{umtsLac=UmtsLac,
          umtsSac=UmtsSac,
          umtsRncId=UmtsRncId,
          umtsCi=UmtsCi,
          rat_id=Rat_id})
    end
  end,
  mnesia:activity(transaction, F).


write_lte(LteEnodeBId, LteCi, Rat_id) ->
  F = fun() ->
    case mnesia:read({radio_access_type, ratTypeId}) =:= [] of
      true -> 
        {error, rat};
      false ->
        mnesia:write(#lte{lteEnodeBId=LteEnodeBId,
          lteCi=LteCi,
          rat_id=Rat_id})
    end
  end,
  mnesia:activity(transaction, F).









