%%%-------------------------------------------------------------------
%%% @author lou
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. May 2021 00:43
%%%-------------------------------------------------------------------
-module(fileProcessor_relational).
-author("lou").

%% API
-export([receiveFile/1,parse/1]).
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
parse(Data) -> Tokens = string:split(Data, ",",all), % maybe change in the other file processor as well
  %printTokens(Tokens),
  case hd(Tokens) of
    "reportingNode" -> header;%io:format("Found header~n");
    _ -> parseData(Tokens)
  end.

%printTokens([]) -> [];
%printTokens(Tokens) -> hd(Tokens).


% parses data to different records.
parseData([ReportingNode,ReportingTs,EventTs,EventType,HMcc,HMnc,HashedImsi,VMcc,VMnc,Rat,CellName,GsmLac,GsmCid,UmtsLac,UmtsSac,UmtsRncId,UmtsCi,LteEnodeBId,LteCi,CellPortionId,LocationEstimateShape,LocationEstimateLat,LocationEstimateLon,LocationEstimateRadius,CrmGender,CrmAgeGroup,CrmZipCode,PresencePointId,GroupPresencePointId]=T) ->
  %io:format(Tokens),
  %Event = #relational_event{hashedImsi=HashedImsi,
  %    reportingTs=ReportingTs,
  %    eventType=EventType
  %  },

  %AnonymousPerson = #anonymous_person{hashedImsi=HashedImsi,
  %    gender=CrmGender,
  %    ageGroup=CrmAgeGroup,
  %    zipCode=CrmZipCode
  %  },

  %Cell = #cell{imsi=HashedImsi,
  %    reportingTs=ReportingTs,
  %    cellName=CellName,
  %    cellPortionId=CellPortionId,
  %    locationEstimateShape=LocationEstimateShape,
  %    locationEstimateLat=LocationEstimateLat,
  %    locationEstimateLon=LocationEstimateLon,
  %    locationEstimateRadius=LocationEstimateRadius
  %  },
  
  %VisitedNetworkInfo = #visisted_network_info{imsi=HashedImsi,
  %    vMcc=VMcc,
  %    vMnc=VMnc},
  
  %HomeNetworkInfo = #home_network_info{imsi=HashedImsi,
  %    hMcc=HMcc,
  %    hMnc=HMnc},
  
  %MobileDevice = #mobile_device{imsi=HashedImsi,
  %    rat=Rat},

  %Node = #node{reportingNode=ReportingNode,
  %    imsi=HashedImsi},

  %RadioAccessType = #radio_access_type{ratType=Rat, 
  %    },
  %io:format(HashedImsi),
  RatTypeId = db_relational:fetchLastEvent(),
  %io:format(RatTypeId),
  improved_db_relational:write_event(ReportingTs,HashedImsi,EventType,EventTs,CellName,ReportingNode,RatTypeId,VMcc,VMnc,GroupPresencePointId,PresencePointId),
  improved_db_relational:write_sim_card_information(CrmGender,CrmAgeGroup,CrmZipCode,HashedImsi,HMcc,HMnc),
  improved_db_relational:write_cell(CellPortionId,CellName,LocationEstimateShape,LocationEstimateLat,LocationEstimateLon,LocationEstimateRadius),
  improved_db_relational:write_radio_access_type(RatTypeId,Rat),

  case Rat of
    "2" -> 
      db_relational:write_gsm(RatTypeId,GsmLac, GsmCid);
    "3" ->
      db_relational:write_umts(RatTypeId,UmtsLac,UmtsSac,UmtsRncId,UmtsCi);
    "4" ->
      db_relational:write_lte(RatTypeId, LteEnodeBId,LteCi);
    _ ->
      db_relational:write_gsm(RatTypeId,GsmLac, GsmCid),
      db_relational:write_umts(RatTypeId,UmtsLac,UmtsSac,UmtsRncId,UmtsCi),
      db_relational:write_lte(RatTypeId, LteEnodeBId,LteCi)
  end.

  

  




  %writeToDb(Event).

% writes event record to db
%writeToDb(Event) -> db_relational:write(Event).

% reportingNode,reportTs,eventTs,eventType,hMcc,hMnc,hashedImsi,vMcc,vMnc,rat,cellName,gsmLac,gsmCid,umtsLac,umtsSac,umtsRncId,umtsCi,lteEnodeBId,lteCi,cellPortionId,locationEstimateShape,locationEstimateLat,locationEstimateLon,locationEstimateRadius,crmGender,crmAgeGroup,crmZipCode,presencePointId,groupPresencePointId