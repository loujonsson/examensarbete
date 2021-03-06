%%%-------------------------------------------------------------------
%%% @author lou
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. Apr 2021 15:38
%%%-------------------------------------------------------------------
-module(outputFileProcessor).
-author("lou").

%% API
-export([generateOutputFile/0]).
-include("main.hrl").


%%% output file grejer:
generateOutputFile() ->
  openFile(write).

openFile(Mode) ->
  Io = case file:open("outputFileTest.txt", Mode) of
    {ok, IoDevice} -> IoDevice;
    {error, _} -> exit(errorOpenFile)
  end,

  case Mode of
    write -> writeToFile(Io);
    "read" -> readHeader(Io)
  end.

readHeader(IoDevice) ->
  "should find header fields in output file".

writeToFile(IoDevice) ->
  Data = formatData(),
  Data,
  file:write_file("outputFileTest.csv", Data).

fetchAttributesFromQuery(Attribute) ->
  LookUp = ets:lookup(query, Attribute),
  if LookUp == "" ->
    "";
  true ->
    queryHandler:fetchEtsData(query, Attribute)
  end.
  

formatData() ->
  %reportingNode,reportTs,eventType,counterValue,counterType,periodStartTs,periodStopTs,statId,statIndex,presencePointId,presencePointIdType,minPresenceNo,hMcc,hMnc,crmGender,crmAgeGroup,crmZipCode,maxPresenceNo,presencePointId2,presencePointId2Type,minDwellTimeCrit,maxDwellTimeCrit,subCat,dayCat,timeCatCRLF
  OutputRecord = #output{reportingNode = "reportingNode1",
    reportingTs = dataTypeConverter:integer_to_string(timeHandler:getNowTimeInUTC()),
    eventType = "3",
    counterValue = queryHandler:fetchEtsData(attributes, counterValue),
    %counterValue = "123",
    %counterType = "3",
    counterType = queryHandler:fetchEtsData(attributes, counterType),
    periodStartTs = dataTypeConverter:integer_to_string(queryHandler:fetchEtsData(query, periodStartTs)),
    periodStopTs = dataTypeConverter:integer_to_string(queryHandler:fetchEtsData(query, periodStopTs)),
    statId = "",
    statIndex = "",
    presencePointId = queryHandler:fetchEtsData(query, "presencePointId"),
    presencePointIdType = queryHandler:fetchEtsData(query, "presencePointIdType"),
    minPresenceNo = queryHandler:fetchEtsData(query, "minPresenceNo"),
    hMcc = queryHandler:fetchEtsData(query, "hMcc"),
    hMnc = queryHandler:fetchEtsData(query, "hMnc"),
    crmGender = queryHandler:fetchEtsData(query, "gender"),
    crmAgeGroup = queryHandler:fetchEtsData(query, "ageGroup"),
    crmZipCode = queryHandler:fetchEtsData(query, "zipCode"),
    maxPresenceNo = queryHandler:fetchEtsData(query, "maxPresenceNo"),
    presencePointId2 = "",
    presencePointId2Type = "",
    minDwellTimeCrit = "",
    maxDwellTimeCrit = "",
    subCat = "",
    dayCat = "",
    timeCat = ""
  },
  %io:format(OutputRecord#output.reportingNode),
  %io:format("hej~n"),
  %io:format(OutputRecord#output.reportTs),
  %io:format("hej~n"),
  %io:format(OutputRecord#output.eventType),
  %%io:format("hej~n"),
  %io:format(OutputRecord#output.crmZipCode),
  %io:format("hej~n"),
  %io:format(OutputRecord#output.counterValue),
  % varf??r ens g??ra en record d???
  OutputFileDataList = [OutputRecord#output.reportingNode,
    OutputRecord#output.reportingTs,
    OutputRecord#output.eventType,
    OutputRecord#output.counterValue,
    OutputRecord#output.counterType,
    OutputRecord#output.periodStartTs,
    OutputRecord#output.periodStopTs,
    OutputRecord#output.statId,
    OutputRecord#output.statIndex,
    OutputRecord#output.presencePointId,
    OutputRecord#output.presencePointIdType,
    OutputRecord#output.minPresenceNo,
    OutputRecord#output.hMcc,
    OutputRecord#output.hMnc,
    OutputRecord#output.crmGender,
    OutputRecord#output.crmAgeGroup,
    OutputRecord#output.crmZipCode,
    OutputRecord#output.maxPresenceNo,
    OutputRecord#output.presencePointId2,
    OutputRecord#output.presencePointId2Type,
    OutputRecord#output.minDwellTimeCrit,
    OutputRecord#output.maxDwellTimeCrit,
    OutputRecord#output.subCat,
    OutputRecord#output.dayCat,
    OutputRecord#output.timeCat,
    "CLRF"],
  %io:format("lous test"),
  Header = "reportingNode,reportTs,eventType,counterValue,counterType,periodStartTs,periodStopTs,statId,statIndex,presencePointId,presencePointIdType,minPresenceNo,hMcc,hMnc,crmGender,crmAgeGroup,crmZipCode,maxPresenceNo,presencePointId2,presencePointId2Type,minDwellTimeCrit,maxDwellTimeCrit,subCat,dayCat,timeCatCRLF",
  Data = string:join(OutputFileDataList, ","),
  TextFile = string:join([Header, Data], "\n"),
  %Data = lists:concat(OutputFileDataList),
  TextFile.

  %"reportNode1", "1538388005000", "3", queryHandler:fetchQuery("totalOccurrences"), queryHandler:fetchQuery("counterType"), "_", "_"]
  %Row1 = "testing",
  %Row2 = "test data 2",
  %Data = string:join([Row1, Row2], "\n"),
  %Data.



