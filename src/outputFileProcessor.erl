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
  openFile("write").

openFile(Mode) ->
  Io = case file:open("outputFileTest.txt", Mode) of
    {ok, IoDevice} -> IoDevice;
    {error, _} -> exit(errorOpenFile)
  end,

  case Mode of
    "write" -> writeToFile(Io);
    "read" -> readHeader(Io)
  end.

readHeader(IoDevice) ->
  "should find header fields in output file".

writeToFile(IoDevice) ->
  Data = formatData(),
  file:write_file("outputFileTest.txt", Data).

formatData() ->
  %reportingNode,reportTs,eventType,counterValue,counterType,periodStartTs,periodStopTs,statId,statIndex,presencePointId,presencePointIdType,minPresenceNo,hMcc,hMnc,crmGender,crmAgeGroup,crmZipCode,maxPresenceNo,presencePointId2,presencePointId2Type,minDwellTimeCrit,maxDwellTimeCrit,subCat,dayCat,timeCatCRLF
  OutputRecord = #output{reportingNode = "reportingNode1",
    reportTs = "1538388005000",
    eventType = "3",
    counterValue = queryHandler:fetchEtsData(attributes, "counterValue"),
    counterType = queryHandler:fetchEtsData(attributes, "counterType"),
    periodStartTs = "",
    periodStopTs = "",
    statId = "",
    statIndex = "",
    presencePointId = "",
    presencePointIdType = "",
    minPresenceNo = "",
    hMcc = "",
    hMnc = "",
    crmGender = queryHandler:fetchEtsData(query, "gender"),
    crmAgeGroup = queryHandler:fetchEtsData(query, "ageGroup"),
    crmZipCode = queryHandler:fetchEtsData(query, "zipCode"),
    maxPresenceNo = "",
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
  % varför ens göra en record då?
  OutputFileDataList = [OutputRecord#output.reportingNode,
    OutputRecord#output.reportTs,
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



