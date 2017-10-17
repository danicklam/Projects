

SEL 

event_actual_date,  RM_EVENT_CODE, count (Location_ID),
count(distinct FULL_BARCODE), count (distinct EVENT_ID)
FROM EDW_SCVER_BO_VIEWS.V_BO_BASE_TRACK_DATA_DTL
WHERE RM_Event_Code LIKE 'EVK%'
AND RM_Event_Code <>  'EVKLC'
AND RM_Event_Code <> 'EVKLS'
AND Del_status IN ('Delivered','Undelivered')
AND Event_Actual_Date BETWEEN date '2017-09-01' AND date '2017-10-05'
group by 1,2
;