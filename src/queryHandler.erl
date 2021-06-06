%%%-------------------------------------------------------------------
%%% @author lou
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%% ide
%%% köra query:
%%% read data from inputDB
%%% save data in variable
%%% when done command -> take all that data as input in outputDB
%%% format file from output DB.
%%%
%%% @end
%%% Created : 22. Apr 2021 14:53
%%%-------------------------------------------------------------------
-module(queryHandler).
-author("lou").

%% API
-export([receiveValidCommand/1, receiveQueryAttribute/1, queryInit/0, attributesInit/0, fetchEts/2, fetchEtsData/2]).

% initializes query with an ets table
queryInit() ->
  ets:new(query, [named_table, public, set, {keypos, 1}]).
  %ets:insert(query, {"gender", {}}), %{0,1,2}
  %ets:insert(query, {"ageGroup", {}}), %{0,1,2,3,4,5,6}
  %ets:insert(query, {"zipCode", {}}).

% initializes statistics attributes with an ets table
attributesInit() ->
  ets:new(attributes, [named_table, public, set, {keypos, 1}]),
  ets:insert(attributes, {counterType, {0}}),
  ets:insert(attributes, {counterValue, {0}}).


% fetch ets data depending on ets table name Name and attribute inside of ets table LookupArg
fetchEts(Name, LookupArg) ->
  %[{_, Data}]
  ets:lookup(Name, LookupArg).


% returns the data in ets table Name with attribute LookupArg
fetchEtsData(Name, LookupArg) ->
  %List = ets:lookup(Name, LookupArg),
  [{_, Data}] = ets:lookup(Name, LookupArg),
  case Data of 
    {} -> "";
    [] -> "";
    Data -> Data
  end.


% receive valid command from script interpreter
% 'done' formats current query and clears it and sends signal to outputFileProcessor to generate an output file
% 'clear' means reset current query
receiveValidCommand(Command) ->
  case Command of
    done ->
      Query = formatQuery(),
      clearQuery(),
      Results = receiveDone(Query),
      outputFileProcessor_bench:generateOutputFile(Results);
    clear -> clearQuery()
    %_ -> setNewAttributeQuery(Tokens)
  end.


% receives valid query attribute from script interpreter
receiveQueryAttribute({AttributeType, Attribute}) ->
    setNewAttributeQuery({AttributeType, Attribute}).


% resets current query...
clearQuery() ->
  io:format("Reset current query...~n"),
  ets:delete(query),
  %ets:delete(attributes),
  queryInit().


% sets new query attribute in ets table
setNewAttributeQuery({AttributeType, Attribute}) ->
  ets:insert(query, {AttributeType, Attribute}).


% format query in ets table to list
formatQuery() ->
  ets:tab2list(query).


% Received 'done' as command and formatted query as argument Query
% Calls function which extracts query attributes from list Query
receiveDone(Query) -> 
  io:format("Received done.~n"),
  ResultsTuple = getElementsFromList(Query),
  ResultsTuple.


% Extracts data from list
getElementsFromList([]) -> [];
getElementsFromList([{AttributeType, Attribute}]) -> 
  HashedImsis = getDataFromNonRelationalDb(AttributeType, Attribute),
  {AttributeType, Attribute, HashedImsis};
  %HashedImsis = getDataFromRelationalDb(AttributeType, Attribute),
  %{AttributeType, Attribute, HashedImsis};
  %getDataFromRelationalDb(AttributeType, Attribute);
getElementsFromList([_| T]) ->
  getElementsFromList(T).


% Searches for the selected AttributeType with attribute Attribute from database (nonrelational)
getDataFromNonRelationalDb(AttributeType, Attribute) ->
  UniqueHashedImsis = db_nonrelational:select(non_relational_event, AttributeType, Attribute),
  UniqueHashedImsis.
  %countOccurrences(Data).


% Searches for the selected AttributeType with attribute Attribute from database (relational)
getDataFromRelationalDb(AttributeType, Attribute) ->
  UniqueHashedImsis = db_relational:select(sim_card_information, AttributeType, Attribute),
  UniqueHashedImsis.
  %countOccurrences(Data).


% count total occurrences and store in attributes ets table
countOccurrences(Data) ->
  Length = length(Data),
  TotalOccurrences = to_string(Length),
  ets:insert(attributes, {counterValue, {TotalOccurrences}}).


% Converts number (int) to a string representation
to_string(Number) ->
  lists:flatten(io_lib:format("~p", [Number])).

