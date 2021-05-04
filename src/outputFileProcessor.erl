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


%%% output file grejer:
generateOutputFile() ->
  openFile().

openFile() ->
  Io = case file:open("outputFileTest.txt", write) of
    {ok, IoDevice} -> IoDevice;
    {error, _} -> exit(errorOpenFile)
  end,
  writeToFile(Io).

writeToFile(IoDevice) ->
  Data = formatData(),
  file:write_file("outputFileTest.txt", Data).

formatData() ->
  Header = "reportingNode,reportTs,eventType,counterValue,counterType,periodStartTs,periodStopTs,statId,statIndex,presencePointId,presencePointIdType,minPresenceNo,hMcc,hMnc,crmGender,crmAgeGroup,crmZipCode,maxPresenceNo,presencePointId2,presencePointId2Type,minDwellTimeCrit,maxDwellTimeCrit,subCat,dayCat,timeCatCRLF",
  Row1 = "testing",
  Data = string:join([Header, Row1], "\n"),
  Data.



