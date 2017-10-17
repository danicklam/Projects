/*
DROP TABLES
DROP TABLE MGRS_LAM.BLS_P;
DROP TABLE MGRS_LAM.BLS_PP;
DROP TABLE MGRS_LAM.BLS_PP2;
DROP TABLE MGRS_LAM.BLS_PPE;
*/

/*
POSTCODES IN THREE AREAS - APPROX (1,713,577 DELIVERY POINTS)
select count (distinct PAF_UDPRN) from edw_scver_coda_dim_views.v_dim_address;
(31,708,206 UDPRNS)
*/
--------------------------------------------------------------------------------

/*
INDIVIDUAL CLUSTERS DATA EXTRACT
PHASE 1 - CREATE REFERENCE ADDRESSES
*/

create table MGRS_LAM.BLS_P
as (
sel distinct 
Address_ID, PAF_UDPRN
from edw_scver_coda_accs_views.v_dim_address
where postcode_area IN ('B','LS','SN') 
) with data
;
collect statistics column (Address_ID) on MGRS_LAM.BLS_P;
/*
sel count (*) from MGRS_LAM.BLS_P;
sel top 10 * from MGRS_LAM.BLS_P;
*/

--------------------------------------------------------------------------------
/*
INDIVIDUAL CLUSTERS DATA EXTRACT
PHASE 2 - LINK TO ADDRESSESS  
*/

create multiset table MGRS_LAM.BLS_PP
as (
sel distinct
PA.party_id, IND.indiv_cluster_id, P.PAF_UDPRN, PA.address_id
from MGRS_LAM.BLS_P P
inner join edw_scver_coda_accs_views.v_party_address PA
on P.address_id = PA.Address_id and PA.Address_type_id = 1
inner join edw_scver_coda_accs_views.v_individual IND
on IND.party_id = PA.party_id
)with data 
;
collect statistics column (PARTY_ID) on MGRS_LAM.BLS_PP;
/*
sel count (*) from MGRS_LAM.BLS_PP;
sel top 10 * from MGRS_LAM.BLS_PP;
collect statistics column (PARTY_ID) on MGRS_LAM.BLS_PP;
*/

--------------------------------------------------------------------------------
/*
INDIVIDUAL CLUSTERS DATA EXTRACT
PHASE 3 - LINK TO EMAILS_IDS 
*/

create multiset table MGRS_LAM.BLS_PP2
as (
sel 
PP.*, PA.address_id as Electronic_address_id
from MGRS_LAM.BLS_PP PP
left join edw_scver_coda_accs_views.v_party_address PA
on PA.party_id = PP.party_id
and PA.address_type_id = 2
) with data
;
collect statistics column (ELECTRONIC_ADDRESS_ID) on MGRS_LAM.BLS_PP2;

/*
sel count (*) from MGRS_LAM.BLS_PP2;
sel top 10 * from MGRS_LAM.BLS_PP2;
sel count (*) from EDW_SCVER_CODA_ACCS_VIEWS.v_party_source_dtl 
where address_type_id = 2 and data_source_cd <> 'PARCELS';

sel top 10 * from edw_scver_coda_accs_views.v_party_privacy_preferences;
sel count (*) from EDW_SCVER_CODA_ACCS_VIEWS.v_party_source_dtl where address_type_id = 2 and data_source_cd <> 'PARCELS';
sel top 10 * from edw_scver_coda_accs_views.v_address_type;
sel count (*) from (sel address_id, indiv_cluster_id, PAF_UDPRN
from MGRS_LAM.BLS_PP2 GROUP BY 1,2,3)x ;
*/

--------------------------------------------------------------------------------
/*
INDIVIDUAL CLUSTERS DATA EXTRACT
PHASE 4 - LINK TO EMAIL ADDRESSESS  
*/
create multiset table MGRS_LAM.BLS_PPE
as (
sel 
PP2.*, EA.electronic_address, psd.data_source_cd
from MGRS_LAM.BLS_PP2 PP2
left join edw_scver_coda_accs_views.v_electronic_address EA  --- sel count (*) from edw_scver_coda_accs_views.v_electronic_address
on PP2.electronic_address_id = EA.electronic_address_id
left join EDW_SCVER_CODA_ACCS_VIEWS.v_party_source_dtl psd
on psd.party_id = pp2.party_id
and psd.data_source_cd = 'TODS'
and psd.address_id = pp2.electronic_address_id
and psd.address_type_id = 2
) with data
;

/*
sel top 100 * from MGRS_LAM.BLS_PPE
where data_source_cd = 'TODS'
and electronic_address_id is null;
*/

------------------------------------------------------------------------------------
/*
EMAIL SUPPRESSION STEP
*/

create multiset volatile table VT_TODS_EMAIL_SENDERS AS
(
sel distinct ttpa.org_name, stld.recip_email_addr  from
EDW_SCVER_BO_VIEWS.V_TODS_TRACKED_PRE_ADVICE TTPA
inner join
EDW_SCVER_CODA_ACCS_VIEWS.V_SALES_TRANSACTION_LINE_DTLS stld
on stld.sales_tran_line_id = ttpa.sales_tran_line_id
and stld.recip_email_addr is not null
and ttpa.org_name not in ( 
'MARKS & SPENCER PLC',
'River Island',
'River Island Clothing Co',
'URBAN OUTFITTERS INC.',
'4PX',
'4PX WORLDWIDE EXPRESS CO. LIMITED',
'4PX WORLDWIDE EXPRESS CO. LTD'
)
) WITH DATA
on commit preserve rows;


/*
INDIVIDUAL CLUSTERS DATA EXTRACT
PENULTIMATE PHASE BEFORE HASHING
*/

create multiset table MGRS_LAM.BLS_PPET
as (
select PAF_UDPRN as UDPRN,
trim(address_id)||lpad(cast(indiv_cluster_id as varchar(4)),4,'0000') as Cluster_ID, Electronic_address
from MGRS_LAM.BLS_PPE
where indiv_cluster_id is not null
and paf_udprn > 1
and electronic_address is not null
and exists 
(select distinct recip_email_addr
from VT_TODS_EMAIL_SENDERS
where recip_email_addr = electronic_address
)
group by 1,2,3   --- 1.9mill   allowed emails
UNION
select PAF_UDPRN as UDPRN,
trim(address_id)||lpad(cast(indiv_cluster_id as varchar(4)),4,'0000') as Cluster_ID, '' as Electronic_address
from MGRS_LAM.BLS_PPE mgrs
where indiv_cluster_id is not null
and paf_udprn > 1
and electronic_address is not null
and not exists 
(select distinct recip_email_addr
from VT_TODS_EMAIL_SENDERS
where recip_email_addr = electronic_address
)
group by 1,2,3    --- 0.8 mill   suppressed emails 
UNION
select PAF_UDPRN as UDPRN,
trim(address_id)||lpad(cast(indiv_cluster_id as varchar(4)),4,'0000') as Cluster_ID, Electronic_address
from MGRS_LAM.BLS_PPE
where indiv_cluster_id is not null
and Electronic_address is null
and paf_udprn > 1
group by 1,2,3   ---0.9 mill      no emails
)with data;

---- MAKE SURE TO DROP THE VOLATILE TABLE ON COMPLETION OF INDIVIDUALS TABLE
DROP TABLE
VT_TODS_EMAIL_SENDERS
;

------- THEN CREATE EMAIL APPENDED TABLE

create multiset table MGRS_LAM.BLS_PPEO
as (
sel 
PP2.*, EA.electronic_address, psd.data_source_cd
from MGRS_LAM.BLS_PP2 PP2
inner join edw_scver_coda_accs_views.v_electronic_address EA  --- sel count (*) from edw_scver_coda_accs_views.v_electronic_address
on PP2.electronic_address_id = EA.electronic_address_id
inner join EDW_SCVER_CODA_ACCS_VIEWS.v_party_source_dtl psd
on psd.party_id = pp2.party_id
and psd.data_source_cd <> 'TODS'
and psd.address_id = pp2.electronic_address_id
and psd.address_type_id = 2
)with data;

---     select top 10 * from  MGRS_LAM.BLS_PPEO

CREATE multiset table MGRS_LAM.BLS_PPEF 
as (
select PAF_UDPRN as UDPRN,
trim(address_id)||lpad(cast(indiv_cluster_id as varchar(4)),4,'0000') as Cluster_ID, Electronic_address
from MGRS_LAM.BLS_PPEO
where indiv_cluster_id is not null
and paf_udprn > 1
and electronic_address is not null
union 
select * from MGRS_LAM.BLS_PPET
) with data;

select 
UDPRN, CLUSTER_ID, MAX(ELECTRONIC_ADDRESS) 
FROM MGRS_LAM.BLS_PPEF 
GROUP BY 1,2
;

-------- THEN RUN HASHING JOB FROM/BY DAVID GAMBLE

-------------------------------------------
/*
POSTCODES DATA EXTRACT
*/

SELECT DISTINCT POSTCODE
from edw_scver_coda_accs_views.v_dim_address
where postcode_area IN ('B','LS','SN') 
;

-------------------------------------------
/*
VOLUMES DATA EXTRACT
CHANGES DATES ACCORDINGLY AND RUN PER MONTH, ALSO CHANGE THE HARD-CODED MONTH VALUE
*/
-----

select 
ppe.paf_udprn as UDPRN, 
trim(ppe.address_id)||lpad(cast(ppe.indiv_cluster_id as varchar(4)),4,'0000') as CLUSTER_ID, 
org.organization_name as SENDERS_NAME, 
dst.data_source_type_desc as SOURCE_SYSTEM, 
'APRIL' as "MONTH",
count (distinct ep.piece_id) as COUNT_OF_ITEMS

from EDW_SCVER_CODA_ACCS_VIEWS.v_event_party EP
inner join MgrS_LAM.BLS_PPE PPE  -- sel top 10 * from MgrS_LAM.BLS_PPE
on PPE.party_id = EP.PARTY_ID and EP.data_source_type_id IN (1, 5, 11) and EP.event_party_role_id = 1
and PPE.paf_udprn > 1
and ep.event_actual_dt between date '2017-04-01' and date '2017-04-30'
left join EDW_SCVER_CODA_ACCS_VIEWS.v_event_party EP2
on EP2.event_id = ep.event_id and EP2.event_party_role_id =2 and ep2.data_source_type_id IN (5,11)
left join EDW_SCVER_CODA_ACCS_VIEWS.v_organization org
on ep2.party_id = org.party_id 
inner join EDW_SCVER_CODA_ACCS_VIEWS.v_data_source_type dst ----sel top 10 * from EDW_SCVER_CODA_ACCS_VIEWS.v_data_source_type
on dst.data_source_type_id = ep.data_source_type_id
group by 1,2,3,4,5

UNION select 
ppe.paf_udprn as UDPRN, 
trim(ppe.address_id)||lpad(cast(ppe.indiv_cluster_id as varchar(4)),4,'0000') as CLUSTER_ID, 
tpa.org_name as SENDERS_NAME, 
dst.data_source_type_desc as SOURCE_SYSTEM, 
'APRIL' as "MONTH",
count (distinct ep.piece_id) as COUNT_OF_ITEMS

from EDW_SCVER_CODA_ACCS_VIEWS.v_event_party EP
inner join MgrS_LAM.BLS_PPE PPE  -- sel top 10 * from MgrS_LAM.BLS_PPE
on PPE.party_id = EP.PARTY_ID and EP.data_source_type_id IN (2) and EP.event_party_role_id = 1
and PPE.paf_udprn > 1
and ep.event_actual_dt between date '2017-04-01' and date '2017-04-30'
left join EDW_SCVER_CODA_ACCS_VIEWS.V_SALES_TRANSACTION_LINE STL
on EP.PIECE_ID = STL.PIECE_ID
left join EDW_SCVER_BO_VIEWS.V_TODS_TRACKED_PRE_ADVICE TPA
on tpa.sales_tran_line_id = stl.sales_tran_line_id
inner join EDW_SCVER_CODA_ACCS_VIEWS.v_data_source_type dst ----sel top 10 * from EDW_SCVER_CODA_ACCS_VIEWS.v_data_source_type
on dst.data_source_type_id = ep.data_source_type_id
group by 1,2,3,4,5
;



/*
sel top 10 * from SYS_CALENDAR.Calendar;

sel max(address_id) from MGRS_LAM.BLS_PPE; --- 3,694,634,241
sel max(indiv_cluster_id) from MGRS_LAM.BLS_PPE;   --- 3173

sel count (*) from MGRS_LAM.BLS_PPE;                                         --  41,498,714
sel count (*) from MGRS_LAM.BLS_PPE where electronic_address_id is null;     --  38,173,677
sel count (*) from MGRS_LAM.BLS_PPE where electronic_address_id is not null; --   3,325,037
sel count (distinct address_id||indiv_cluster_id) from MGRS_LAM.BLS_PPE;     --  12,090,170
sel count (*) from edw_scver_coda_accs_views.v_individual;                   -- 894,407,227
sel top 10 * from MGRS_LAM.BLS_PPE
where electronic_address_id is not null;

sel top 10 * from edw_scver_coda_accs_views.v_address_type;
sel top 10 * from edw_scver_coda_accs_views.v_electronic_address;
sel top 10 * from edw_scver_coda_accs_views.v_individual;

drop table
show table edw_scver.party_archive;

sel count (*) from edw_scver_coda_accs_views.v_dim_address
where postcode_area IN ('B','LS','SN'); -- 1,713,577
  
select count (*)
from edw_scver_coda_accs_views.v_party_address pa
inner join edw_scver_coda_accs_views.v_dim_address da
on da.address_id = pa.address_id
and da.postcode_area IN ('B','LS','SN'); --- 50,149,746


select psd.data_source_cd, count (distinct ea.electronic_address_id)
from edw_scver_coda_accs_views.v_party_address pa --- sel top 10 * from edw_scver_coda_accs_views.v_party_address
inner join edw_scver_coda_accs_views.v_party_source_dtl psd 
on pa.party_id = psd.party_id
and pa.address_id = psd.address_id
and psd.address_type_id = 2
inner join edw_scver_coda_accs_views.v_electronic_address ea  
on ea.electronic_address_id = pa.address_id
and ea.electronic_address_id = psd.address_id
and pa.address_type_id = 2
group by 1
;

sel top 10 * from edw_scver_bo_views.v_bo_base_track_data_dtl;
sel top 10 * from edw_scver_bo_views.v_bo_base_track_data;


sel top 10 * from edw_scver_bo_views.v_Shipper_Piece;
sel top 10 * from edw_scver_bo_views.v_Postal_Piece_Event;
sel top 10 * from edw_scver_coda_accs_views.v_Sales_Transaction_Line;
--sel top 10 * from edw_scver_coda_accs_views.v_Sales_Transaction_Line_dtls;
sel top 10 * from edw_scver_coda_accs_views.v_Sales_Transaction where source_system = 'TODS';
sel top 10 * from edw_scver_bo_views.v_Delivery;
sel top 10 * from edw_scver_bo_views.v_Postal_Exception;
sel top 10 * from edw_scver_bo_views.v_Exception_Reason;


sel top 10 * from  edw_scver_coda_accs_views.v_event_party
where data_source_type_id = 2;

sel top 10 * from  edw_scver_coda_accs_views.v_data_source_type;


sel count(*) from 
edw_scver_coda_accs_views.v_Sales_Transaction_Line stl
inner join
edw_scver_coda_accs_views.v_Sales_Transaction st
on stl.sales_tran_id = st.sales_tran_id
and st.source_system = 'TODS'
where (postcode is null or postcode ='')
;

sel top 10 * from 
edw_scver_coda_accs_views.v_Sales_Transaction_Line stl
inner join
edw_scver_coda_accs_views.v_Sales_Transaction st
on stl.sales_tran_id = st.sales_tran_id
and st.source_system = 'TODS'
and stl.promised_fulfillment_dt = date '2017-09-01'
;
sel top 100 * from
edw_scver_bo_views.v_Sales_order;


SELECT * FROM EDW_SCVER_CODA_ACCS_VIEWS.V_PARTY
WHERE 
PARTY_ID IN
(1919126203
,3365395346
,1893213
,807523878
,2258070707
,1863093
,3210920467
,1069755290
,2260483442
,3103848602)


*/