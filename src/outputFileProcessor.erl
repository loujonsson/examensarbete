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
-export([receiveDone/1]).

receiveDone(Query) -> io:format("received done."),
  [{ageGroup,AgeTypes},{zipCode,ZipTypes},{gender,GenderTypes}] = Query,
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
  Tokens = string:tokens(Data,","),
  length(Tokens).