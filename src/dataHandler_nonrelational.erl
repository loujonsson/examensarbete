%%%-------------------------------------------------------------------
%%% @author lou
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. May 2021 00:23
%%%-------------------------------------------------------------------
-module(dataHandler_nonrelational).
-author("lou").

%% API
-export([parseData/1]).
-include("main.hrl").


% parses data to event record
parseData(eof) -> eof;
parseData([ReportingNode,ReportTs,EventTs,EventType,HMcc,HMnc,HashedImsi,VMcc,VMnc,Rat,CellName,GsmLac,GsmCid,UmtsLac,UmtsSac,UmtsRncId,UmtsCi,LteEnodeBId,LteCi,CellPortionId,LocationEstimateShape,LocationEstimateLat,LocationEstimateLon,LocationEstimateRadius,CrmGender,CrmAgeGroup,CrmZipCode,PresencePointId,GroupPresencePointId] = Tokens) ->
  %io:format(Tokens),
  Event = #event{reportingNode = ReportingNode,
    reportTs = ReportTs,
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
  },
  writeToDb(Event).

% writes event record to db
writeToDb(Event) -> db_nonrelational:write(Event).