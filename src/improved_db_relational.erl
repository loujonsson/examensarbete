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
-export([install/1, start/2, stop/1, fetchLastEvent/0, write_event/11, write_sim_card_information/6, write_cell/6, write_radio_access_type/2, write_gsm/3, write_umts/5, write_lte/3, traverse_table_and_show/1, read_test/1, clearAllTables/0, select_test/1]).
-include("main.hrl").


install(Nodes) ->
  ok = mnesia:create_schema(Nodes),
  %timer:sleep(1000),
  %rpc:multicall(Nodes, application, start, [mnesia]),
  application:start(mnesia),

  mnesia:create_table(sim_card_information,
    [{attributes, record_info(fields, sim_card_information)},
      %{index, [#sim_card_information.hashedImsi]},
      {disc_copies, Nodes}]),

  mnesia:create_table(cell,
      [{attributes, record_info(fields, cell)},
      %{index, [#cell.cellName]},
      {disc_copies, Nodes}]),
  
   mnesia:create_table(relational_event,
      [{attributes, record_info(fields, relational_event)},
      {index, [#relational_event.ratTypeId]},
      {disc_copies, Nodes}]),  

    mnesia:create_table(radio_access_type,
      [{attributes, record_info(fields, radio_access_type)},
      %{index, [#radio_access_type.ratTypeId]},
      {disc_copies, Nodes}]), 

    mnesia:create_table(gsm,
      [{attributes, record_info(fields, gsm)},
      %{index, [#gsm.rat_id]},
      {disc_copies, Nodes}]), 

    mnesia:create_table(umts,
      [{attributes, record_info(fields, umts)},
      %{index, [#umts.rat_id]},
      {disc_copies, Nodes}]), 

    mnesia:create_table(lte,
      [{attributes, record_info(fields, lte)},
      %{index, [#lte.rat_id]},
      {disc_copies, Nodes}]).

    %rpc:multicall(Nodes, application, stop, [mnesia]). % rpc allows mnesia action on all nodes.


% wait for at most 5 seconds until tables are available.
start(normal, []) ->
  %mnesia:wait_for_tables([anonymous_person, cell, visited_network_info, home_network_info, mobile_device, node, main_event, radio_access_type, gsm, umts, lte], 5000).
  mnesia:wait_for_tables([sim_card_information, cell, relational_event, radio_access_type, gsm, umts, lte], 5000).


stop(_) -> ok.


% adds relational event to the database. 
% TODO: maybe check if eventType = 1? No check yet.
write_event(ReportingTs, HashedImsi,EventType, EventTs, CellName, ReportingNode, Rat, VMcc, VMnc,GroupPresencePointId,PresencePointId) ->
  F = fun() ->
    mnesia:write(#relational_event{
      hashedImsi=HashedImsi, 
      reportingTs=ReportingTs,
      eventType=EventType,
      eventTs=EventTs,
      cellName=CellName,
      reportingNode=ReportingNode,
      ratTypeId=Rat,
      vMcc=VMcc,
      vMnc=VMnc,
      groupPresencePointId=GroupPresencePointId,
      presencePointId=PresencePointId})
    end, 
  mnesia:activity(transaction, F). 

% fetch last event in relational database, in table relational_event
fetchLastEvent() ->
  F = fun() -> 
    case mnesia:last(relational_event) of
      '$end_of_table' -> empty;
      _ -> mnesia:last(relational_event)
    end
  end,
  HashedImsi = mnesia:activity(transaction,F),
  
  readEventId(HashedImsi).

% fetch last ratTypeId on last event
readEventId(empty) -> 1;
readEventId(HashedImsi) -> 
  F = fun() -> 
    case mnesia:read({relational_event, HashedImsi}) of
      [Event] ->
        Id = fetchEventId(Event),
        increment(Id);
      [] ->
        undefined
    end
  end,
  mnesia:activity(transaction, F).

fetchEventId(Event)->
  Event#relational_event.ratTypeId.

increment(Id) -> Id+1.

read_test(HashedImsi) ->
  F = fun() ->
    mnesia:read({relational_event, HashedImsi})
  end,
  mnesia:activity(transaction,F).
  
% adds an anonymous person if the hashed imsi is already in the database, otherwise returns error.
write_sim_card_information(Gender, AgeGroup, ZipCode, HashedImsi,HMcc, HMnc) ->
  F = fun() ->  
    mnesia:write(#sim_card_information{
      gender=Gender,
      ageGroup=AgeGroup,
      zipCode=ZipCode,
      hashedImsi=HashedImsi,
      hMcc=HMcc,
      hMnc=HMnc})
  end,
  mnesia:activity(transaction, F).

% add cell to db
% event_id should be a tuple or list or something consisting of hashed imsi and reporting ts.
write_cell(CellPortionId,CellName, LocationEstimateShape, LocationEstimateLat, LocationEstimateLon, LocationEstimateRadius) ->
  F = fun() ->
    mnesia:write(#cell{
      cellPortionId=CellPortionId,
      cellName=CellName,
      locationEstimateShape=LocationEstimateShape,
      locationEstimateLat=LocationEstimateLat,
      locationEstimateLon=LocationEstimateLon,
      locationEstimateRadius=LocationEstimateRadius})
  end,
  mnesia:activity(transaction, F).

% add radio raccess type record to database without id, but generating id inside function scope
write_radio_access_type(RatTypeId,RatType) ->
  F = fun() ->
    mnesia:write(#radio_access_type{ratTypeId=RatTypeId,
      ratType=RatType})
  end,
  mnesia:activity(transaction, F).

% add gsm info to database
write_gsm(Rat_id,GsmLac, GsmCid) ->
  F = fun() ->
    mnesia:write(#gsm{rat_id=Rat_id,
      gsmLac=GsmLac,
      gsmCid=GsmCid})
  end,
  mnesia:activity(transaction, F).


write_umts(Rat_id,UmtsLac, UmtsSac, UmtsRncId, UmtsCi) ->
  F = fun() ->
    mnesia:write(#umts{rat_id=Rat_id,
      umtsLac=UmtsLac,
      umtsSac=UmtsSac,
      umtsRncId=UmtsRncId,
      umtsCi=UmtsCi})
  end,
  mnesia:activity(transaction, F).


write_lte(Rat_id, LteEnodeBId, LteCi) ->
  F = fun() ->
    mnesia:write(#lte{rat_id=Rat_id,
      lteEnodeBId=LteEnodeBId,
      lteCi=LteCi})
  end,
  mnesia:activity(transaction, F).

% clears all data in all tables in the relational database.
clearAllTables()->
  mnesia:clear_table(relational_event),
  mnesia:clear_table(sim_card_information),
  mnesia:clear_table(cell),
  mnesia:clear_table(radio_access_type),
  mnesia:clear_table(gsm),
  mnesia:clear_table(umts),
  mnesia:clear_table(lte). 

% read through requested table, with table name as attribute
traverse_table_and_show(Table_name)->
  Iterator =  fun(Rec,_)->
    io:format("~p~n",[Rec]),
    []
              end,
  case mnesia:is_transaction() of
    true -> mnesia:foldl(Iterator,[],Table_name);
    false ->
      Exec = fun({Fun,Tab}) -> mnesia:foldl(Fun, [],Tab) end,
      mnesia:activity(transaction,Exec,[{Iterator,Table_name}],mnesia_frag)
  end.

select_test(RatTypeId)->
  F = fun() ->
    MatchHead = #relational_event{ 
          hashedImsi='$1',
          ratTypeId=RatTypeId,
          _ = '_'
        },
    mnesia:select(relational_event, [{MatchHead, [], ['$1']}])
  end,
  mnesia:activity(transaction,F).
  

