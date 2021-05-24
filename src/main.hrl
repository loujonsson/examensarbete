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
-record(event, {reportingNode,reportTs,eventTs,eventType,hMcc,hMnc,hashedImsi,vMcc,vMnc,rat,cellName,gsmLac,gsmCid,umtsLac,umtsSac,umtsRncId,umtsCi,lteEnodeBId,lteCi,cellPortionId,locationEstimateShape,locationEstimateLat,locationEstimateLon,locationEstimateRadius,crmGender,crmAgeGroup,crmZipCode,presencePointId,groupPresencePointId}).

% Output record
-record(output, {reportingNode,reportTs,eventType,counterValue,counterType,periodStartTs,periodStopTs,statId,statIndex,presencePointId,presencePointIdType,minPresenceNo,hMcc,hMnc,crmGender,crmAgeGroup,crmZipCode,maxPresenceNo,presencePointId2,presencePointId2Type,minDwellTimeCrit,maxDwellTimeCrit,subCat,dayCat,timeCat}).


% for relational database.
-record(anonymous_person, {hashedImsi,
    gender,
    ageGroup,
    zipCode}).
-record(cell, {imsi,
    reportingTs,
    cellName,
    cellPortionId,
    locationEstimateShape,
    locationEstimateLat,
    locationEstimateLon,
    locationEstimateRadius}).
-record(visited_network_info, {imsi,
    vMcc,
    vMnc}).
-record(home_network_info, {imsi,
    hMcc,
    hMnc}).
-record(mobile_device, {imsi, 
    rat}).
-record(node, {reportingNode,
    imsi}).
-record(main_event, {imsi,
    reportingTs,
    eventType}). % = 1
-record(radio_access_type, {ratType,
    ratTypeId}).
-record(gsm, {gsmLac,
    gsmCid,
    rat_id}).
-record(umts, {umtsLac,
    umtsSac,
    umtsRncId,
    umtsCi,
    rat_id}).
-record(lte, {lteEnodeBId,
    lteCi,
    rat_id}).