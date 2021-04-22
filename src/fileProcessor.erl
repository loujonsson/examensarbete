%%%-------------------------------------------------------------------
%%% @author lou
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Apr 2021 17:02
%%%-------------------------------------------------------------------
-module(fileProcessor).
-author("lou").

%% API
-export([receiveFile/1]).
-include("main.hrl").

receiveFile(File) ->
  openFile(File).

openFile(File) ->
  Io = case file:open(File, read) of
         {ok, IoDevice} -> IoDevice;
         {error, _} -> exit(nofile)
       end,
  readLine(Io).

readLine(Io) ->
  case file:read_line(Io) of
    {ok, Data} -> parse(Data), readLine(Io);
    eof -> exit(eof);
    {error, _} -> exit(errorreadline)
  end.

parse(Data) -> Tokens = string:tokens(Data, ","),
  printTokens(Tokens),
  case hd(Tokens) of
    "reportingNode" -> io:format("Found header~n");
    _ -> parseData(Tokens)
  end.

printTokens([]) -> [];
printTokens(Tokens) -> io:format("heeej~n"), hd(Tokens).

parseData([ReportingNode,ReportTs,EventTs,EventType,HMcc,HMnc,HashedImsi,VMcc,VMnc,Rat,CellName,GsmLac,GsmCid,UmtsLac,UmtsSac,UmtsRncId,UmtsCi,LteEnodeBId,LteCi,CellPortionId,LocationEstimateShape,LocationEstimateLat,LocationEstimateLon,LocationEstimateRadius,CrmGender,CrmAgeGroup,CrmZipCode,PresencePointId,GroupPresencePointId] = Tokens) ->
  io:format(Tokens),
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

writeToDb(Event) -> nonrelational_db:write(Event).

% reportingNode,reportTs,eventTs,eventType,hMcc,hMnc,hashedImsi,vMcc,vMnc,rat,cellName,gsmLac,gsmCid,umtsLac,umtsSac,umtsRncId,umtsCi,lteEnodeBId,lteCi,cellPortionId,locationEstimateShape,locationEstimateLat,locationEstimateLon,locationEstimateRadius,crmGender,crmAgeGroup,crmZipCode,presencePointId,groupPresencePointId