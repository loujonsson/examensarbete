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
  openFile(read).

openFileRead() ->
  Io = case file:open("outputFileTest.txt", read) of
         {ok, IoDevice} -> IoDevice;
         {error, _} -> exit(nofile)
       end,
  readHeader(Io).

openFile(Mode) ->
  Io = case file:open("outputFileTest.txt", write) of
    {ok, IoDevice} -> IoDevice;
    {error, _} -> exit(errorOpenFile)
  end,
  writeToFile(Io).

writeToFile(IoDevice) ->
  Data = formatData(),
  file:write_file("outputFileTest.txt", Data).

formatData() ->
  Row1 = "testing",
  Row2 = "test data 2",
  Data = string:join([Row1, Row2], "\n"),
  Data.



