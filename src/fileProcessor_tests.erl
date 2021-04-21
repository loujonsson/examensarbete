%%%-------------------------------------------------------------------
%%% @author lou
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Apr 2021 14:44
%%%-------------------------------------------------------------------
-module(fileProcessor_tests).
-author("lou").

-include_lib("eunit/include/eunit.hrl").

fileProcessor_tests_test_() ->
  [
    {"Test parse", fun parse_test/0},
    {"Test add two", fun addTwo_test/0}
  ].

addTwo_test() ->
  ?assertEqual(2, fileProcessor:addTwo(0)).

%unstick,
parse_test() ->
  meck:new(string, [passthrough]),
  meck:expect(string, tokens, fun(_, ",") -> tokens end),
  ?assertEqual(fileProcessor:parse(reportingNode,reportTs,eventTs,eventType,hMcc,hMnc,hashedImsi,vMcc,vMnc,rat,cellName,gsmLac,gsmCid,umtsLac,umtsSac,umtsRncId,umtsCi,lteEnodeBId,lteCi,cellPortionId,locationEstimateShape,locationEstimateLat,locationEstimateLon,locationEstimateRadius,crmGender,crmAgeGroup,crmZipCode,presencePointId,groupPresencePointIdCRLF), foundHeader),
  %?assertEqual("written to db", fileProcessor:receiveFile('input1ValidLine.txt')),
  %?assertEqual({error, enoent}, fileProcessor:receiveFile('test.txt')),
  ?assert(meck:validate(string)),
  meck:unload(string).

%simple_test() ->
%  ?assert(true).
