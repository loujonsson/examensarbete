%%%-------------------------------------------------------------------
%%% @author lou
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Apr 2021 12:55
%%%-------------------------------------------------------------------
-author("lou").

% For input file, storing all events in the mnesia database
-record(non_relational_event, {reportingNode,reportingTs,eventTs,eventType,hMcc,hMnc,hashedImsi,vMcc,vMnc,rat,cellName,gsmLac,gsmCid,umtsLac,umtsSac,umtsRncId,umtsCi,lteEnodeBId,lteCi,cellPortionId,locationEstimateShape,locationEstimateLat,locationEstimateLon,locationEstimateRadius,crmGender,crmAgeGroup,crmZipCode,presencePointId,groupPresencePointId}).

% Output record
-record(output, {reportingNode,reportingTs,eventType,counterValue,counterType,periodStartTs,periodStopTs,statId,statIndex,presencePointId,presencePointIdType,minPresenceNo,hMcc,hMnc,crmGender,crmAgeGroup,crmZipCode,maxPresenceNo,presencePointId2,presencePointId2Type,minDwellTimeCrit,maxDwellTimeCrit,subCat,dayCat,timeCat}).


% for relational database.
-record(sim_card_information, {
    hashedImsi,
    gender,
    ageGroup,
    zipCode,
    hMcc,
    hMnc}).

-record(cell, {
    cellName,
    cellPortionId,
    locationEstimateShape,
    locationEstimateLat,
    locationEstimateLon,
    locationEstimateRadius}).

%-record(visited_network_info, {imsi,
%    vMcc,
%    vMnc}).
%-record(home_network_info, {imsi,
%    hMcc,
%    hMnc}).
%-record(mobile_device, {imsi, 
%    rat}).
%-record(node, {reportingNode,
%    imsi}).
-record(relational_event, {
    hashedImsi,
    reportingTs,
    eventType, % = 1
    eventTs,
    %eventType, % = 1
    cellName,
    reportingNode,
    ratTypeId,
    vMcc,
    vMnc,
    groupPresencePointId,
    presencePointId}). 

-record(radio_access_type, {ratTypeId,
    ratType
    }).

-record(gsm, {
    rat_id,
    gsmLac,
    gsmCid}).

-record(umts, {rat_id,
    umtsLac,
    umtsSac,
    umtsRncId,
    umtsCi}).

-record(lte, {rat_id,
    lteEnodeBId,
    lteCi}).