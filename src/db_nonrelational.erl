%%%-------------------------------------------------------------------
%%% @author lou
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Apr 2021 14:57
%%%-------------------------------------------------------------------
-module(db_nonrelational).
-author("lou").

%% API
-export([install/1, write/29, write_dirty/29, write_testEvent/0, traverse_table_and_show/1, select/3,clearAllTables/0]).
-include("main.hrl").

% configure database table in nonrelational database
install(Nodes) ->
  ok = mnesia:create_schema(Nodes),
  application:start(mnesia),
  mnesia:create_table(non_relational_event,
    [{attributes, record_info(fields, non_relational_event)},
      %{index, [#non_relational_event.hashedImsi, #non_relational_event.reportingTs]},
      {disc_copies, Nodes}]).


% write a test event to database
write_testEvent() ->
  EventTest = #non_relational_event{reportingNode = 'reportingN1',
    reportingTs = 1538388005000123,
    eventTs = 153838800000,
    eventType = 1,
    hMcc = 240,
    hMnc = 10,
    hashedImsi = 'AB502941AFE132',
    vMcc = 240,
    vMnc = 10,
    rat = 3,
    %cellName = ,
    %gsmLac = GsmLac,
    %gsmCid = GsmCid,
    umtsLac = 10102,
    umtsSac = 30211,
    umtsRncId = 102,
    umtsCi = 30211,
    %lteEnodeBId = LteEnodeBId,
    %lteCi = LteCi,
    %cellPortionId = CellPortionId,
    locationEstimateShape = 1,
    locationEstimateLat = 59.31683,
    locationEstimateLon = 18.0569,
    locationEstimateRadius = 175,
    crmGender = 1,
    crmAgeGroup = 2,
    crmZipCode = 11010
    %presencePointId = PresencePointId,
    %groupPresencePointId = GroupPresencePointId},
  },
  mnesia:dirty_write(EventTest).

% dirty write to non relational database
write_dirty(ReportingNode,ReportingTs,EventTs,EventType,HMcc,HMnc,HashedImsi,VMcc,VMnc,Rat,CellName,GsmLac,GsmCid,UmtsLac,UmtsSac,UmtsRncId,UmtsCi,LteEnodeBId,LteCi,CellPortionId,LocationEstimateShape,LocationEstimateLat,LocationEstimateLon,LocationEstimateRadius,CrmGender,CrmAgeGroup,CrmZipCode,PresencePointId,GroupPresencePointId) ->
  mnesia:dirty_write(#non_relational_event{reportingNode = ReportingNode,
      reportingTs = ReportingTs,
      eventTs = EventTs,
      eventType = EventType,
      hMcc = HMcc,
      hMnc = HMnc,
      hashedImsi = HashedImsi,
      vMcc = VMcc,
      vMnc = VMnc,
      rat = Rat,
      cellName = CellName,
      gsmLac = GsmLac,
      gsmCid = GsmCid,
      umtsLac = UmtsLac,
      umtsSac = UmtsSac,
      umtsRncId = UmtsRncId,
      umtsCi = UmtsCi,
      lteEnodeBId = LteEnodeBId,
      lteCi = LteCi,
      cellPortionId = CellPortionId,
      locationEstimateShape = LocationEstimateShape,
      locationEstimateLat = LocationEstimateLat,
      locationEstimateLon = LocationEstimateLon,
      locationEstimateRadius = LocationEstimateRadius,
      crmGender = CrmGender,
      crmAgeGroup = CrmAgeGroup,
      crmZipCode = CrmZipCode,
      presencePointId = PresencePointId,
      groupPresencePointId = GroupPresencePointId
    }).

% write to non relational db with transactions
write(ReportingNode,ReportingTs,EventTs,EventType,HMcc,HMnc,HashedImsi,VMcc,VMnc,Rat,CellName,GsmLac,GsmCid,UmtsLac,UmtsSac,UmtsRncId,UmtsCi,LteEnodeBId,LteCi,CellPortionId,LocationEstimateShape,LocationEstimateLat,LocationEstimateLon,LocationEstimateRadius,CrmGender,CrmAgeGroup,CrmZipCode,PresencePointId,GroupPresencePointId) ->
  F = fun() ->
    %mnesia:write_lock_table(non_relational_event),
    mnesia:write(#non_relational_event{
      hashedImsi = HashedImsi,
      reportingTs = ReportingTs,
      reportingNode = ReportingNode,
      
      eventTs = EventTs,
      eventType = EventType,
      hMcc = HMcc,
      hMnc = HMnc,
      vMcc = VMcc,
      vMnc = VMnc,
      rat = Rat,
      cellName = CellName,
      gsmLac = GsmLac,
      gsmCid = GsmCid,
      umtsLac = UmtsLac,
      umtsSac = UmtsSac,
      umtsRncId = UmtsRncId,
      umtsCi = UmtsCi,
      lteEnodeBId = LteEnodeBId,
      lteCi = LteCi,
      cellPortionId = CellPortionId,
      locationEstimateShape = LocationEstimateShape,
      locationEstimateLat = LocationEstimateLat,
      locationEstimateLon = LocationEstimateLon,
      locationEstimateRadius = LocationEstimateRadius,
      crmGender = CrmGender,
      crmAgeGroup = CrmAgeGroup,
      crmZipCode = CrmZipCode,
      presencePointId = PresencePointId,
      groupPresencePointId = GroupPresencePointId
    })
  end, 
  mnesia:transaction(F).


%write(Event) ->
%  F = fun() ->
%    mnesia:write(Event)
%  end,
%  mnesia:activity(transaction, F).

  % write to non relational db with transactions
%write_mini(ReportingNode,EventType) ->
%  io:format(ReportingNode),
%  io:format("~n"),
%  
%  F = fun() ->
%    mnesia:write(#mini_event{reportingNode = ReportingNode,
%      eventType=EventType
%    })
%      end,
%  mnesia:activity(transaction, F).
  %timer:sleep(100).
  %mnesia:info().


select(Table_name, AttributeType, Attribute) ->
  MatchHead = case AttributeType of
    "zipCode" -> select_zipCode(Attribute);
    "gender" -> select_gender(Attribute);
    "ageGroup" -> select_ageGroup(Attribute)
  end,
  mnesia:dirty_select(Table_name, [{MatchHead, [], ['$6']}]).

select_zipCode(ZipCode) ->
  #non_relational_event{reportingNode = '$1',
          %reportTs = '$2',
          %eventTs = '$3',
          %eventType = '$4',
          %hMcc = '$5',
          %hMnc = '$6',
          hashedImsi = '$6',
          %vMcc = '$7',
          %vMnc = '$8',
          %rat = '$9',
          %cellName = '$10',
          %gsmLac = '$11',
          %gsmCid = '$12',
          %umtsLac = '$12',
          %umtsSac = '$13',
          %umtsRncId = '$14',
          %umtsCi = '$15',
          %lteEnodeBId = '$16',
          %lteCi = '$17',
          %cellPortionId = '$18',
          %locationEstimateShape = '$19',
          %locationEstimateLat = '$20',
          %locationEstimateLon = '$21',
          %locationEstimateRadius = '$22',
          crmGender = '$23',
          crmAgeGroup = '$24',
          crmZipCode = ZipCode,
          _ = '_'
        }.

select_ageGroup(AgeGroup) ->
  #non_relational_event{reportingNode = '$1',
          reportingTs = '$2',
          hashedImsi = '$6',
          crmGender = '$23',
          crmAgeGroup = AgeGroup,
          crmZipCode = '$25',
          _ = '_'
        }.

select_gender(Gender) ->
  #non_relational_event{reportingNode = '$1',
          reportingTs = '$2',
          hashedImsi = '$6',
          crmGender = Gender,
          crmAgeGroup = '$24',
          crmZipCode = '$25',
          _ = '_'
        }.



% QLC query list comprehensions
%select_distinct(ZipCode) ->
%  QH = qlc:q(
%    [HashedImsi ||
%      #event{ hashedImsi = HashedImsi,
              %crmGender = 1,
              %crmAgeGroup = 2,
%              crmZipCode = Z,
%              _ = '_'
              %presencePointId = PresencePointId,
              %groupPresencePointId = GroupPresencePointId},
%  } <- mnesia:table(event), Z =:= ZipCode], {unique,true}),
%  F = fun() -> qlc:eval(QH) end,
%  {atomic, Result} = mnesia:transaction(F),
%  Result.

%select_all() ->
%  {atomic, Data} = mnesia:transaction(
%    fun() ->
%      qlc:eval(
%        qlc:q([X || X <- mnesia:table(event)], {unique, true})
%      )
%    end
%  ),
%  Data.

%select_distinct(ZipCode) ->
%  MatchHead = #non_relational_event{%reportingNode = '$1',
%    hashedImsi = '$6',
%    vMcc = '$7',
%    vMnc = '$8',
%    rat = '$9',
%    cellName = '$10',
%    crmGender = '$23',
%    crmAgeGroup = '$24',
%    crmZipCode = '$25',
%    _ = '_'
%  },

  %Guard = {'=', '$25', ZipCode},
  %Result = '$6',
  %{atomic, Data} = mnesia:transaction(
  %  fun() ->
  %    qlc:eval(
  %      qlc:q([X || X <- mnesia:select(non_relational_event, {MatchHead, [Guard], [Result]})], {unique, true})
  %    )
  %  end
  %),
  %Data.

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



clearAllTables()->
  mnesia:clear_table(non_relational_event).

