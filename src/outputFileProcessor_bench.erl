%%%-------------------------------------------------------------------
%%% @author lou
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. Jun 2021 15:46
%%%-------------------------------------------------------------------
-module(outputFileProcessor_bench).
-author("lou").

%% API
-export([generateOutputFile/1]).
-include("main.hrl").


%%% output file grejer:
generateOutputFile(Results) ->
  openFile(Results).

openFile(Results) ->
  Io = case file:open("outputBench.txt", write) of
    {ok, IoDevice} -> IoDevice;
    {error, _} -> exit(errorOpenFile)
  end,
  writeToFile(Io,Results).


writeToFile(IoDevice,Results) ->
  Data = formatData(Results),
  Data,
  file:write_file("outputBench.txt", Data).

formatData({AttributeType, Attribute, Data}) ->
  
  String1 = "Hashed Imsi of Attribute",
  String2 = AttributeType,
  String3 = "where Attribute was",
  String4 = Attribute,
  %String5 = "~n",
  DataString = string:join(Data, ","),
  Info = string:join([String1, String2, String3, String4], " "),
  TextFile = string:join([Info, DataString], "\n"),

  %Data = lists:concat(OutputFileDataList),
  TextFile.

  %"reportNode1", "1538388005000", "3", queryHandler:fetchQuery("totalOccurrences"), queryHandler:fetchQuery("counterType"), "_", "_"]
  %Row1 = "testing",
  %Row2 = "test data 2",
  %Data = string:join([Row1, Row2], "\n"),
  %Data.



