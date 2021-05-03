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
-export([receiveValidCommand/1, queryInit/0, fetchQuery/1, showTable/0]).

%-record(query, {gender, ageGroup}).

%queryInit() ->
%  #query(gender = {1,2},
%    ageGroup = {0,1,2,3,4,5,6}).

queryInit() ->
  ets:new(query, [named_table, public, set, {keypos, 1}]),
  ets:insert(query, {gender, {0,1,2}}),
  ets:insert(query, {ageGroup, {0,1,2,3,4,5,6}}),
  ets:insert(query, {zipCode, {}}).

fetchQuery(LookupArg) ->
  %[{_, Data}]
  ets:lookup(query, LookupArg).

showTable() -> ets:all().


receiveValidCommand(Input) ->
  Tokens = string:tokens(Input, " \n.;="),
  getAttribute(Tokens).

getAttribute(Tokens) ->
  Attribute = hd(Tokens),
  case Attribute of
    "done" ->
      Query = formatQuery(),
      outputFileProcessor:receiveDone(Query);
    "reset" -> resetAllQueries();
    _ -> setNewAttributeQuery(Tokens)
  end.

% hard coded reset queries
resetAllQueries() ->
  io:format("shall reset all queries in output db").
  %CurrentQuery = queryInit().

% ide
% köra query:
% read data from inputDB
% save data in variable
% when done command -> take all that data as input in outputDB
% format file from output DB.
setNewAttributeQuery(Tokens) ->
  case hd(Tokens) of
    "gender" ->
      Elements = lists:delete(gender, Tokens),
      ets:insert(query,  {gender, list_to_tuple(Elements)});
    "ageGroup" ->
      Elements = lists:delete(ageGroup, Tokens),
      ets:insert(query, {ageGroup, list_to_tuple(Elements)});
    "zipCode" ->
      Elements = lists:delete(zipCode, Tokens),
      ets:insert(query, {zipCode, list_to_tuple(Elements)})
  end.

formatQuery() ->
  List = ets:tab2list(query),
  [{ageGroup,AgeTypes},{zipCode,ZipTypes},{gender,GenderTypes}] = List.

