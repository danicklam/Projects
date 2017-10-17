/*
 * FIRST DATA GRAB
 * */

CREATE TABLE  MGRS_LAM.SUBSET_EDW_SAMPLE_EVENTS AS
(
SEL  distinct BBTDL2.EVENT_ID
FROM EDW_SCVER_BO_VIEWS.V_BO_BASE_TRACK_DATA_DTL BBTDL2-- sel top 10 * from EDW_SCVER_BO_VIEWS.V_BO_BASE_TRACK_DATA_DTL
WHERE BBTDL2.RM_Event_Code LIKE 'EVK%'
AND BBTDL2.RM_Event_Code <>  'EVKLC'
AND BBTDL2.RM_Event_Code <> 'EVKLS'
AND BBTDL2.Del_status IN ('Delivered','Undelivered')
AND BBTDL2.Event_Actual_Date BETWEEN date '2017-09-20' AND date '2017-09-27'
SAMPLE 10000
)WITH DATA
;

/*
 * SUBSEQUENT DATA RUNS
 * Change name of table using the date incrementally
 */

CREATE MULTISET TABLE MGRS_LAM.SUBSET_EDW_S20170920_E20170927_R20171016 AS
(
SEL  EVENT_ID, FULL_BARCODE, RM_EVENT_CODE, Del_status, Event_Actual_Date, EVENT_ACTUAL_DTTM,location_id, LATITUDE, LONGITUDE 
FROM EDW_SCVER_BO_VIEWS.V_BO_BASE_TRACK_DATA_DTL BBTDL-- sel top 10 * from EDW_SCVER_BO_VIEWS.V_BO_BASE_TRACK_DATA_DTL
where exists
(
SEL EVENT_ID FROM MGRS_LAM.SUBSET_EDW_SAMPLE_EVENTS MGRS
where mgrs.event_id = BBTDL.EVENT_ID
)
)WITH DATA
;

sel top 10 *  from MGRS_LAM.SUBSET_EDW_S20170920_E20170927_R20171012;
sel count (*) from MGRS_LAM.SUBSET_EDW_S20170920_E20170927_R20171012;
sel count (*) from MGRS_LAM.SUBSET_EDW_S20170920_E20170927_R20171013;
sel count (*) from MGRS_LAM.SUBSET_EDW_S20170920_E20170927_R20171014;
sel top 10 * from EDW_SCVER_BO_VIEWS.V_BO_BASE_TRACK_DATA_DTL BBTDL;
sel event_actual_date, count (*) from EDW_SCVER_BO_VIEWS.V_BO_BASE_TRACK_DATA_DTL BBTDL
group by 1
order by event_actual_date desc;
/*
2017-10-19,2
2017-10-13,8
2017-10-11,474407
2017-10-10,3764435
2017-10-09,3424722
*/


--- THEN compare using minus functions

-- Identify records lost or changed
sel * from MGRS_LAM.SUBSET_EDW_S20170920_E20170927_R20171014
minus
sel * from MGRS_LAM.SUBSET_EDW_S20170920_E20170927_R20171016
;

-- identify records added or changed
sel * from MGRS_LAM.SUBSET_EDW_S20170920_E20170927_R20171016
minus
sel * from MGRS_LAM.SUBSET_EDW_S20170920_E20170927_R20171014
;