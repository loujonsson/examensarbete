%%%-------------------------------------------------------------------
%%% @author lou
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Apr 2021 14:57
%%%-------------------------------------------------------------------
-module(db_nonrelational).
-author("lou").

%% API
-export([install/1, write/1, write_testEvent/0, traverse_table_and_show/1, select/2]).
-include("main.hrl").

install(Nodes) ->
  ok = mnesia:create_schema(Nodes),
  application:start(mnesia),
  mnesia:create_table(event,
    [{attributes, record_info(fields, event)},
      {index, [#event.hashedImsi, #event.reportTs]},
      {disc_copies, Nodes}]).

write_testEvent() ->
  EventTest = #event{reportingNode = 'reportingN1',
    reportTs = 1538388005000,
    eventTs = 153838800000,
    eventType = 1,
    hMcc = 240,
    hMnc = 10,
    hashedImsi = 'AB502941AFE134',
    vMcc = 240,
    vMnc = 10,
    rat = 3,
    %cellName = ,
    %gsmLac = GsmLac,
    %gsmCid = GsmCid,
    umtsLac = 10102,
    umtsSac = 30211,
    umtsRncId = 102,
    umtsCi = 30211,
    %lteEnodeBId = LteEnodeBId,
    %lteCi = LteCi,
    %cellPortionId = CellPortionId,
    locationEstimateShape = 1,
    locationEstimateLat = 59.31683,
    locationEstimateLon = 18.0569,
    locationEstimateRadius = 175,
    crmGender = 1,
    crmAgeGroup = 2,
    crmZipCode = 11010
    %presencePointId = PresencePointId,
    %groupPresencePointId = GroupPresencePointId},
  },
  %mnesia:dirty_write(Event),
  mnesia:dirty_write(EventTest),
  io:format("hello").


write(Event) ->
  mnesia:dirty_write(Event),
  io:format("hello").

select(Table_name, ZipCode) ->
  MatchHead = #event{%reportingNode = '$1',
                  %reportTs = '$2',
                  %eventTs = '$3',
                  %eventType = '$4',
                  %hMcc = '$5',
                  %hMnc = '$6',
                  hashedImsi = '$6',
                  vMcc = '$7',
                  vMnc = '$8',
                  rat = '$9',
                  cellName = '$10',
                  %gsmLac = '$11',
                  %gsmCid = '$12',
                  %umtsLac = '$12',
                  %umtsSac = '$13',
                  %umtsRncId = '$14',
                  %umtsCi = '$15',
                  lteEnodeBId = '$16',
                  lteCi = '$17',
                  cellPortionId = '$18',
                  %locationEstimateShape = '$19',
                  %locationEstimateLat = '$20',
                  %locationEstimateLon = '$21',
                  %locationEstimateRadius = '$22',
                  crmGender = '$23',
                  crmAgeGroup = '$24',
                  crmZipCode = ZipCode,
                  %presencePointId = '$25',
                  %groupPresencePointId = '$26'
                  _ = '_'
                },
  mnesia:dirty_select(Table_name, [{MatchHead, [], ['$6']}]).


traverse_table_and_show(Table_name)->
  Iterator =  fun(Rec,_)->
    io:format("~p~n",[Rec]),
    []
              end,
  case mnesia:is_transaction() of
    true -> mnesia:foldl(Iterator,[],Table_name);
    false ->
      Exec = fun({Fun,Tab}) -> mnesia:foldl(Fun, [],Tab) end,
      mnesia:activity(transaction,Exec,[{Iterator,Table_name}],mnesia_frag)
  end.


