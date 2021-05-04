%%%-------------------------------------------------------------------
%%% @author lou
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. Apr 2021 14:53
%%%-------------------------------------------------------------------
-module(queryHandler).
-author("lou").

%% API
-export([receiveValidCommand/1, queryInit/0, fetchEts/2, showTable/0, fetchEtsData/2]).

%-record(query, {gender, ageGroup}).

%queryInit() ->
%  #query(gender = {1,2},
%    ageGroup = {0,1,2,3,4,5,6}).

queryInit() ->
  ets:new(query, [named_table, public, set, {keypos, 1}]),
  ets:insert(query, {"gender", {}}), %{0,1,2}
  ets:insert(query, {"ageGroup", {}}), %{0,1,2,3,4,5,6}
  ets:insert(query, {"zipCode", {}}),

  ets:new(attributes, [named_table, public, set, {keypos, 1}]),
  ets:insert(attributes, {"counterType", {"0"}}),
  ets:insert(attributes, {"counterValue", {"0"}}).

fetchEts(Name, LookupArg) ->
  %[{_, Data}]
  ets:lookup(Name, LookupArg).

fetchEtsData(Name, LookupArg) ->
  List = ets:lookup(Name, LookupArg),
  {_, Element} = hd(List),
  case Element of
    {Data} -> Data;
    _ -> ""
  end.

showTable() -> ets:all().

receiveValidCommand(Input) ->
  Tokens = string:tokens(Input, " \n.;="),
  getAttribute(Tokens).

getAttribute(Tokens) ->
  Attribute = hd(Tokens),
  case Attribute of
    "done" ->
      Query = formatQuery(),
      %resetAllQueries(),
      receiveDone(Query),
      outputFileProcessor:generateOutputFile();
    "reset" -> resetAllQueries();
    _ -> setNewAttributeQuery(Tokens)
  end.

% hard coded reset queries
resetAllQueries() ->
  io:format("shall reset all queries in output db~n"),
  ets:delete(query),
  ets:delete(attributes),
  queryInit().

% ide
% köra query:
% read data from inputDB
% save data in variable
% when done command -> take all that data as input in outputDB
% format file from output DB.
setNewAttributeQuery(Tokens) ->
  Attribute = hd(Tokens),
  Elements = lists:delete(Attribute, Tokens),
  ets:insert(query, {Attribute, list_to_tuple(Elements)}).

formatQuery() ->
  %List =
  ets:lookup(query, "zipCode"),
    ets:tab2list(query).
  %[{"ageGroup",AgeTypes},{"zipCode",ZipTypes},{"gender",GenderTypes}] = List.


%before in outputFileProcessor
receiveDone(Query) -> io:format("received done.~n"),
  [{"ageGroup",AgeTypes},{"zipCode",ZipTypes},{"gender",GenderTypes}] = Query,
  getElementsFromList(tuple_to_list(ZipTypes)).
%io:format(Query).

getElementsFromList([]) -> [];
getElementsFromList([H]) -> H,
  case H of
    "zipCode" -> ignore;
    _ -> getDataFromDb(H)
  end;
getElementsFromList([_| T]) ->
  getElementsFromList(T).
%Head = lists:nth(1, List),
%getElementsFromList(Head),
%List2 = lists:delete(Head, List),
%getElementsFromList(List2).

getDataFromDb(ZipCode) ->
  Data = db_nonrelational:select(event, ZipCode),
  countOccurrences(Data).

countOccurrences(Data) ->
  %Tokens = string:tokens(Data,","),
  %length(Tokens).
  Length = length(Data),
  TotalOccurrences = to_string(Length),
  ets:insert(attributes, {"counterValue", {TotalOccurrences}}).

to_string(Number) ->
  lists:flatten(io_lib:format("~p", [Number])).

