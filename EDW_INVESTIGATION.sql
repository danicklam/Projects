



---- GET RUN DATES
CREATE VOLATILE TABLE RUN_DATES
AS
(SEL CURRENT_DATE AS END_DATE,
		  CASE WHEN CAST(CAST(CURRENT_DATE AS DATE FORMAT'e4') AS CHAR(9)) = 'Monday'  	 THEN CURRENT_DATE - 21
					  WHEN CAST(CAST(CURRENT_DATE AS DATE FORMAT'e4') AS CHAR(9)) = 'Tuesday'  	 THEN CURRENT_DATE - 22
					  WHEN CAST(CAST(CURRENT_DATE AS DATE FORMAT'e4') AS CHAR(9)) = 'Wednesday' THEN CURRENT_DATE - 23
					  WHEN CAST(CAST(CURRENT_DATE AS DATE FORMAT'e4') AS CHAR(9)) = 'Thursday'  	 THEN CURRENT_DATE - 24
					  WHEN CAST(CAST(CURRENT_DATE AS DATE FORMAT'e4') AS CHAR(9)) = 'Friday'  		 THEN CURRENT_DATE - 25
					  WHEN CAST(CAST(CURRENT_DATE AS DATE FORMAT'e4') AS CHAR(9)) = 'Saturday'  	 THEN CURRENT_DATE - 26
 					  WHEN CAST(CAST(CURRENT_DATE AS DATE FORMAT'e4') AS CHAR(9)) = 'Sunday'  		 THEN CURRENT_DATE - 27
					  ELSE CURRENT_DATE
		  END AS START_DATE
) WITH DATA
ON COMMIT PRESERVE ROWS;	






CREATE  VOLATILE MULTISET TABLE TEMP_CR635_OPTIMIZE AS
(
SEL  LATITUDE, LONGITUDE, FULL_BARCODE, RM_EVENT_CODE, EVENT_ID ,EVENT_ACTUAL_DTTM,Event_Actual_Date,location_id
FROM EDW_SCVER_BO_VIEWS.V_BO_BASE_TRACK_DATA_DTL
WHERE RM_Event_Code LIKE 'EVK%'
                AND RM_Event_Code <>  'EVKLC'
                AND RM_Event_Code <> 'EVKLS'
                AND Del_status IN ('Delivered','Undelivered')
				AND Event_Actual_Date BETWEEN date '2017-09-01' AND date'2017-09-05'
)WITH DATA
ON COMMIT PRESERVE ROWS;
-- RT 1:49

/* FOR TESTING
--*****************
SEL RM_EVENT_CODE, MIN(EVENT_ACTUAL_DTTM), MIN(EVENT_ACTUAL_Date), MAX(EVENT_ACTUAL_DTTM), MAX(EVENT_ACTUAL_Date)
FROM TEMP_CR635_OPTIMIZE
GROUP BY 1
*/

CREATE VOLATILE MULTISET TABLE  TODS_CR635_OPTIMIZE_um AS
(
SELECT --TOP 9999999
vbo.event_id event_id,
vbo.EVENT_ACTUAL_DTTM event_dttm,
vbo.rm_event_code event_cd,
vbo.latitude latitude,
vbo.longitude longitude,
vbo.full_barcode barcode,
vpa.party_id party_id,
vpa.address_id address_id,
vda.postcode postcode,
vda.delivery_point_suffix_val delivery_point,
vdaoh.delivery_office do_name
--vbo.event_id event_id,
--vbo.EVENT_ACTUAL_DTTM event_dttm,
--MAX(vbo.rm_event_code) event_cd,
--MAX(vbo.latitude) latitude,
--MAX(vbo.longitude) longitude,
--MAX(vbo.full_barcode) barcode,
--MAX(vpa.party_id) party_id,
--MAX(vpa.address_id) address_id,
--MAX(vda.postcode) postcode,
--MAX(vda.delivery_point_suffix_val) delivery_point,
--MAX(vdaoh.delivery_office) do_name
FROM 
(
                SELECT latitude, longitude, full_barcode, a.location_id, rm_event_code, event_id ,event_actual_date,EVENT_ACTUAL_DTTM
                FROM TEMP_CR635_OPTIMIZE a
                WHERE event_actual_date BETWEEN date '2017-09-01' AND date'2017-09-05' 
) vbo
INNER JOIN 
(
                SELECT event_id,party_id FROM EDW_SCVER_CODA_ACCS_VIEWS.v_event_party
                WHERE event_actual_dt  BETWEEN date '2017-09-01' AND date'2017-09-05'
                AND Event_Party_Role_Id = 1
) vep  --RECIPIENT
                --Note: this isn't 1 to 1. events can have multiple parties, hence the group by.
ON vep.event_id = VBO.event_id
INNER JOIN 
( 
                SELECT party_id,address_id FROM EDW_SCVER_CODA_ACCS_VIEWS.v_party_address 
                WHERE address_type_id = 1
) vpa --Postal Address
ON vpa.party_id = vep.party_id
INNER JOIN 
(
                SELECT delivery_point_suffix_val,postcode,address_id  FROM EDW_SCVER_CODA_ACCS_VIEWS.v_dim_address 
                WHERE address_type = 'MA'
) vda --MAIN ADDRESS
ON vda.address_id = vpa.address_id
INNER JOIN 
(
                SELECT * FROM EDW_SCVER_CODA_DIM_VIEWS.v_dim_address_ops_hierarchy 
                WHERE delivery_office = 'Belfast BT17 DO'
                ) vdaoh
                ON vdaoh.address_id = vpa.address_id
              --GROUP BY 1,2
)WITH DATA
ON COMMIT PRESERVE ROWS;
-- RT 27:23


sel * 
from TODS_CR635_OPTIMIZE_um a
lEFT outer JOIN TODS_CR635_OPTIMIZE b
ON A.EVENT_ID = B.EVENT_ID
AND A.event_dttm = B.EVENT_DTTM
AND A.PARTY_ID = B.PARTY_ID
;

/*
SELECT * FROM EDW_SCVER_CODA_ACCS_VIEWS.V_PARTY
WHERE PARTY_ID in
(1074414281)
;

SELECT * FROM EDW_SCVER_CODA_ACCS_VIEWS.V_PARTY_type

*/


--SEL COUNT(*) FROM TODS_CR635_OPTIMIZE

DROP TABLE Mgrs_Parcels.TODS_CR635_OPTIMIZE;

CREATE  MULTISET TABLE  Mgrs_Parcels.TODS_CR635_OPTIMIZE 
AS
(
SEL * FROM TODS_CR635_OPTIMIZE
) WITH DATA;



-------------------------------------------------------------------------------------


select 
vd.event_id event_id,
vbo.location_id,
vda.postcode postcode,
vda.delivery_point_suffix_val delivery_point,
vd.event_actual_dttm event_dttm
from ( select * from  prod_scver_db.delivery where source_system = 'TODS' ) vd  
join prod_scver_db.temp_party_address_DIM_address vep  on vep.event_id = vd.event_id
join (select * from  prod_scver_db.bo_base_track_data_dtl where RM_Event_Code LIKE 'EVK%'  AND RM_Event_Code <>  'EVKLC' AND  RM_Event_Code <> 'EVKLS') vbo 
on vbo.event_id = vd.event_id
join prod_scver_db.dim_address vda        on vda.address_id = vep.address_id;
truncate table prod_scver_db.event;
insert overwrite table prod_scver_db.event partition (source='TODS') 
select distinct e.event_id, l.location_id, l.location_name_rln, e.postcode, e.delivery_point, e.event_dttm
from (select distinct event_id, location_id, postcode, delivery_point, event_dttm from  prod_scver_db.event_temp)e
inner join prod_scver_db.location l
on l.location_id = e.location_id;
truncate table prod_scver_db.event_textfile;
insert overwrite table prod_scver_db.event_textfile partition(source='TODS') select distinct id,dolocationid,doname,postcode,dps,ts from prod_scver_db.event where source='TODS';