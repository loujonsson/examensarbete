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
