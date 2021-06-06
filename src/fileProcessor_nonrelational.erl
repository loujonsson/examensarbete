%%%-------------------------------------------------------------------
%%% @author lou
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Apr 2021 17:02
%%%-------------------------------------------------------------------
-module(fileProcessor_nonrelational).
-author("lou").

%% API
-export([receiveFile/1,parse/1,readLine/1,parseData/1]).
-include("main.hrl").

% receives file from main module
receiveFile(File) ->
  openFile(File).

% opens file
openFile(File) ->
  Io = case file:open(File, read) of
         {ok, IoDevice} -> IoDevice;
         {error, _} -> exit(nofile)
       end,
  readLine(Io).

% read line of file until end of character is found.
readLine(Io) ->
  case file:read_line(Io) of
    {ok, Data} -> parse(Data), readLine(Io);
    eof -> eof;
      %exit(eof);
    {error, _} -> exit(errorreadline)
  end.

% parse data to tokens with "," as separator
parse(Data) -> 
  Tokens = string:split(Data, ",",all),
  %printTokens(Tokens),
  case hd(Tokens) of
    "reportingNode" -> header;%io:format("Found header~n");
    _ -> parseData(Tokens)
  end.

%printTokens([]) -> [];
%printTokens(Tokens) -> hd(Tokens).

% parses data to event record
%parseData_new([ReportingNode,ReportingTs,EventTs,EventType,HMcc,HMnc,HashedImsi,VMcc,VMnc,Rat,CellName,GsmLac,GsmCid,UmtsLac,UmtsSac,UmtsRncId,UmtsCi,LteEnodeBId,LteCi,CellPortionId,LocationEstimateShape,LocationEstimateLat,LocationEstimateLon,LocationEstimateRadius,CrmGender,CrmAgeGroup,CrmZipCode,PresencePointId,GroupPresencePointId]) ->
%  %io:format(ReportingNode),
%  %io:format("~n"),
%  %io:format(Tokens),
%  Event = #non_relational_event{reportingNode = ReportingNode,
%      reportingTs = ReportingTs,
%      eventTs = EventTs,
%      eventType = EventType,
%      hMcc = HMcc,
%      hMnc = HMnc,
%      hashedImsi = HashedImsi,
%      vMcc = VMcc,
%      vMnc = VMnc,
%      rat = Rat,
%      cellName = CellName,
%      gsmLac = GsmLac,
%      gsmCid = GsmCid,
%      umtsLac = UmtsLac,
%      umtsSac = UmtsSac,
%      umtsRncId = UmtsRncId,
%      umtsCi = UmtsCi,
%      lteEnodeBId = LteEnodeBId,
%      lteCi = LteCi,
%      cellPortionId = CellPortionId,
%      locationEstimateShape = LocationEstimateShape,
%      locationEstimateLat = LocationEstimateLat,
%      locationEstimateLon = LocationEstimateLon,
%      locationEstimateRadius = LocationEstimateRadius,
%      crmGender = CrmGender,
%      crmAgeGroup = CrmAgeGroup,
%      crmZipCode = CrmZipCode,
%      presencePointId = PresencePointId,
%      groupPresencePointId = GroupPresencePointId
%    },
%  db_nonrelational:write_new(Event).


% parses data to event record
%parseData([ReportingNode,ReportingTs,EventTs,EventType,HMcc,HMnc,HashedImsi,VMcc,VMnc,Rat,CellName,GsmLac,GsmCid,UmtsLac,UmtsSac,UmtsRncId,UmtsCi,LteEnodeBId,LteCi,CellPortionId,LocationEstimateShape,LocationEstimateLat,LocationEstimateLon,LocationEstimateRadius,CrmGender,CrmAgeGroup,CrmZipCode,PresencePointId,GroupPresencePointId]) ->
  %io:format(ReportingNode),
  %io:format("~n"),
  %io:format(Tokens),
  %db_nonrelational:write(ReportingNode,ReportingTs,EventTs,EventType,HMcc,HMnc,HashedImsi,VMcc,VMnc,Rat,CellName,GsmLac,GsmCid,UmtsLac,UmtsSac,UmtsRncId,UmtsCi,LteEnodeBId,LteCi,CellPortionId,LocationEstimateShape,LocationEstimateLat,LocationEstimateLon,LocationEstimateRadius,CrmGender,CrmAgeGroup,CrmZipCode,PresencePointId,GroupPresencePointId).
  %%if 
  %  State =/= ok ->
  %    io:format("waiting...");
  %true ->
  %  continue
  %end.

parseData([ReportingNode,ReportingTs,EventTs,EventType,HMcc,HMnc,HashedImsi,VMcc,VMnc,Rat,CellName,GsmLac,GsmCid,UmtsLac,UmtsSac,UmtsRncId,UmtsCi,LteEnodeBId,LteCi,CellPortionId,LocationEstimateShape,LocationEstimateLat,LocationEstimateLon,LocationEstimateRadius,CrmGender,CrmAgeGroup,CrmZipCode,PresencePointId,GroupPresencePointId]) ->
  %Event = #lou_event{reportingNode = ReportingNode,
  %    reportingTs = ReportingTs,
  %    hashedImsi = HashedImsi
  %  },
  db_nonrelational:write(ReportingNode,ReportingTs,EventTs,EventType,HMcc,HMnc,HashedImsi,VMcc,VMnc,Rat,CellName,GsmLac,GsmCid,UmtsLac,UmtsSac,UmtsRncId,UmtsCi,LteEnodeBId,LteCi,CellPortionId,LocationEstimateShape,LocationEstimateLat,LocationEstimateLon,LocationEstimateRadius,CrmGender,CrmAgeGroup,CrmZipCode,PresencePointId,GroupPresencePointId).

% writes event record to db
%writeToDb(Event) -> db_nonrelational:write(Event).

% reportingNode,reportTs,eventTs,eventType,hMcc,hMnc,hashedImsi,vMcc,vMnc,rat,cellName,gsmLac,gsmCid,umtsLac,umtsSac,umtsRncId,umtsCi,lteEnodeBId,lteCi,cellPortionId,locationEstimateShape,locationEstimateLat,locationEstimateLon,locationEstimateRadius,crmGender,crmAgeGroup,crmZipCode,presencePointId,groupPresencePointId