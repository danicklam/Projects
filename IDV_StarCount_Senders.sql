

sel unique_mail_id, pre_adv_unique_item_id from  -- sel top 10 * from EDW_SCVER_CODA_ACCS_VIEWS.v_pcl_ana_rep
EDW_SCVER_CODA_ACCS_VIEWS.v_pcl_ana_rep
where reporting_dt = date '2017-09-01'
;

sel *
from edw_scver_coda_accs_views.v_base_mpe bmpe   --- sel top 10 * from edw_scver_coda_accs_views.v_base_mpe
inner join 
edw_scver_coda_accs_views.v_base_pre_advice bpa   --- sel top 10 * from edw_scver_coda_accs_views.v_base_pre_advice
on bmpe.xxx = bpa.xxx
inner join
edw_scver_coda_accs_views.v_base_pre_adv_item_detail  bpaid   --- sel top 10 * from edw_scver_coda_accs_views.v_base_pre_adv_item_detail
on
bpaid.pre_adv_trans_id = bps.pre_adv_trans_id
;

sel top 10 * from edw_scver_coda_accs_views.v_shipper_piece   --- sel top 10 * from edw_scver_coda_accs_views.v_shipper_piece
where source_system = 'PARCELS';


/*
sel top 10* from edw_scver_coda_dim_views.v_dim_address;
*/

-- Select  event_actual_date, count (*)

create volatile table vt_parcels as
(
sel sp.destination_address_id, count(distinct sp.mail_piece_id) as distinct_parcels, count(*) as scans_count
from edw_scver_coda_accs_views.v_shipper_piece sp   
inner join
edw_scver_coda_accs_views.v_base_mpe bmpe
on bmpe.unique_mail_id = sp.mail_piece_id
and sp.source_system = 'PARCELS'
and sp.event_actual_date = '2017-09-14'
group by 1
) with data;


sel address_id, sum (distinct_parcels), sum (scans_count) from 
edw_scver_coda_dim_views.v_dim_address da
left join  vt_parcels
on da.address_id = sp.destination_address_id
;


----------------
Create multiset table MGRS_LAM.TEST_STARCOUNT_EVENTS_JUL AS (

select sp.destination_address_id, ep.party_id, bpa.sender_name, 'PARCELS' as Data_Source, count (distinct ep.piece_id) as Cnt 
from MgrS_LAM.BLS_PP2 PP2
inner join edw_scver_coda_accs_views.v_event_party ep
on PP2.party_id = ep.party_id
inner join edw_scver_coda_accs_views.v_shipper_piece sp
on ep.piece_id = sp.piece_id
and ep.data_source_type_id = 11
and ep.event_actual_dt between date '2017-07-01' and date '2017-07-31'
and sp.event_actual_date between date '2017-07-01' and date '2017-07-31'
inner join EDW_SCVER_CODA_ACCS_VIEWS.v_pcl_ana_rep pcl
on sp.mail_piece_id = pcl.unique_mail_id
and pcl.reporting_dt between date '2017-07-01' and date '2017-07-31'
inner join edw_scver_coda_accs_views.v_base_pre_adv_item_detail  bpaid
on bpaid.UNIQUE_ITEM_ID  = pcl.MPE_PRE_ADV_KEY
and bpaid.production_dt between date '2017-07-01' and date '2017-07-31'
inner join edw_scver_coda_accs_views.v_base_pre_advice bpa   
on bpaid.pre_adv_trans_id = bpa.pre_adv_trans_id
group by 1, 2, 3, 4
) with data
;

sel count (*) from EDW_SCVER_BO_VIEWS.v_pcl_ana_rep; -- sel top 10 * from EDW_SCVER_BO_VIEWS.v_pcl_ana_rep; 
sel count (*) from EDW_SCVER_CODA_ACCS_VIEWS.v_pcl_ana_rep;




sel reporting_dt, count (*) from
EDW_SCVER_CODA_ACCS_VIEWS.v_pcl_ana_rep
group by 1
;



sel * from MGRS_LAM.TEST_STARCOUNT_EVENTS_JUL
--where substr(sender_name,1,1) = 'U'
order by Cnt desc;
sel count (*) from MGRS_LAM.TEST_STARCOUNT_EVENTS;       --376211
sel count (*) from MGRS_LAM.TEST_STARCOUNT_EVENTS_AUG;   --477016
sel count (*) from MGRS_LAM.TEST_STARCOUNT_EVENTS_JUL;   --477016

----------------
--- sel top 10 * from edw_scver_coda_accs_views.v_base_pre_advice
--- sel top 10 * from edw_scver_coda_accs_views.v_base_pre_adv_item_detail


sel distinct (org.Organization_name) from edw_scver_coda_accs_views.v_event_party ep
inner join 
edw_scver_coda_accs_views.v_organization org
on org.party_id = ep.party_id
and ep.event_party_role_id = 2
and ep.data_source_type_id = 11
and ep.event_actual_dt = date '2017-09-01'
and substr(org.Organization_name,1,1) IN ('R', 'M', 'J', 'U')
;


sel count (distinct electronic_address_id) 
from edw_scver_coda_accs_views.v_electronic_address ea ---sel top 10 * from edw_scver_coda_accs_views.v_electronic_address;
inner join
 edw_scver_coda_accs_views.v_party_source_dtl psd
 on psd.address_id = ea.electronic_address_id
 and psd.address_type_id = 2
;


sel count (distinct electronic_address_id) 
from edw_scver_coda_accs_views.v_electronic_address ea ---sel top 10 * from edw_scver_coda_accs_views.v_electronic_address;
inner join edw_scver_coda_accs_views.v_party_source_dtl psd
on psd.address_id = ea.electronic_address_id
and psd.address_type_id = 2
;   --- 39,653,641

sel count (distinct electronic_address_id) 
from edw_scver_coda_accs_views.v_electronic_address ea ---sel top 10 * from edw_scver_coda_accs_views.v_electronic_address;
inner join edw_scver_coda_accs_views.v_party_source_dtl psd  --sel top 10 * from edw_scver_coda_accs_views.v_party_source_dtl;
on psd.address_id = ea.electronic_address_id
and psd.address_type_id = 2
and psd.data_source_cd <> 'PARCELS'
;  --- 39,645,445




sel * from
edw_scver_coda_accs_views.v_organization
where substr(Organization_name,1,12) --IN ('R', 'M', 'J', 'U');
IN( 'RIVER ISLAND','River Island') ;

sel * from
edw_scver_coda_accs_views.v_organization
where substr(Organization_name,1,11) = 'JD WILLIAMS' OR substr(Organization_name,1,12) = 'J D WILLIAMS';


sel * from
edw_scver_coda_accs_views.v_organization
where substr(Organization_name,1,3) = 'M&S' 
OR substr(Organization_name,1,5) = 'M & S'
OR substr(Organization_name,1,15) = 'Marks & Spencer'
OR substr(Organization_name,1,17) = 'Marks and Spencer'
OR substr(Organization_name,1,17) = 'MARKS AND SPENCER'
OR substr(Organization_name,1,15) = 'MARKS & SPENCER'
;



sel * from 
edw_scver_coda_accs_views.v_organization;


sel top 10* from edw_scver_coda_accs_views.v_party_source_dtl
where address_type_id = 2
and data_source_cd ='PARCELS';


sel top 10 * from  edw_scver_coda_accs_views.v_address_type;


sel sp.destination_address_id, ep.party_id, bpa.sender_name, 'PARCELS' as Data_Source, count (distinct ep.piece_id) 
from  
edw_scver_coda_accs_views.v_base_pre_advice bpa   --- sel top 10 * from edw_scver_coda_accs_views.v_base_pre_advice
inner join
edw_scver_coda_accs_views.v_base_pre_adv_item_detail  bpaid   --- sel top 10 * from edw_scver_coda_accs_views.v_base_pre_adv_item_detail
on bpaid.pre_adv_trans_id = bpa.pre_adv_trans_id
inner join 
EDW_SCVER_CODA_ACCS_VIEWS.v_pcl_ana_rep pcl
on bpaid.UNIQUE_ITEM_ID  = pcl.MPE_PRE_ADV_KEY
inner join 
edw_scver_coda_accs_views.v_shipper_piece sp
on sp.mail_piece_id = pcl.unique_mail_id
and sp.event_actual_date between date '2017-09-01' and date '2017-09-30'
and bpaid.production_dt between date '2017-09-01' and date '2017-09-30'
and pcl.reporting_dt between date '2017-09-01' and date '2017-09-30'
inner join edw_scver_coda_accs_views.v_event_party ep
on ep.piece_id = sp.piece_id
and ep.data_source_type_id = 11
and ep.event_actual_dt between date '2017-09-01' and date '2017-09-30'
group by 1, 2, 3, 4
;

select top 10 * from 
edw_scver_coda_accs_views.v_event_party
where data_source_type_id = 11
;
select top 10 * from 
edw_scver_coda_accs_views.v_shipper_piece
;


select top 10 * from edw_scver_coda_accs_views.v_shipper_piece;

sel top 10 * from edw_scver_coda_accs_views.v_base_mpe;

sel top 10 bpaid.* from
edw_scver_coda_accs_views.v_base_pre_advice bpa   --- sel top 10 * from edw_scver_coda_accs_views.v_base_pre_advice
inner join
edw_scver_coda_accs_views.v_base_pre_adv_item_detail  bpaid   --- sel top 10 * from edw_scver_coda_accs_views.v_base_pre_adv_item_detail
on bpaid.pre_adv_trans_id = bpa.pre_adv_trans_id
and production_dt = date'2017-09-01' 
;

sel top 1999 sp.mail_piece_id, 'shipper' as sourcez from 
edw_scver_coda_accs_views.v_shipper_piece sp
where sp.event_actual_date = date '2017-09-01'
and sp.source_system = 'PARCELS'
union
sel top 1999 bpaid.unique_item_id, 'source' as sourcez from
edw_scver_coda_accs_views.v_base_pre_advice bpa   --- sel top 10 * from edw_scver_coda_accs_views.v_base_pre_advice
inner join
edw_scver_coda_accs_views.v_base_pre_adv_item_detail  bpaid   --- sel top 10 * from edw_scver_coda_accs_views.v_base_pre_adv_item_detail
on bpaid.pre_adv_trans_id = bpa.pre_adv_trans_id
and production_dt = date'2017-09-01' 
;


sel count (*) from 
edw_scver_coda_accs_views.v_base_pre_adv_item_detail; -- 628670478
sel top 10 * from 
edw_scver_coda_accs_views.v_base_pre_adv_item_detail;
sel count (*) from
edw_scver_coda_accs_views.v_base_pre_advice;
sel top 10 * from 
edw_scver_coda_accs_views.v_base_pre_advice;


sel distinct sender_name from 
edw_scver_coda_accs_views.v_base_pre_advice
where substr(sender_name,1,1) IN ('U', 'M', 'R', 'J');

sel distinct sender_name from 
edw_scver_coda_accs_views.v_base_pre_advice
WHERE SENDER_NAME IN (
'River Island',
'RIVER ISLAND CLOTHING COMPANY',
'MARKS & SPENCER PLC',
'MARKS AND SPENCER GROUP P.L.C.',
'MARKS AND SPENCER GROUP PLC',
'URBAN OUTFITTERS DIRECT')
;


sel substr(file_sub_dttm, 1, 10) ,  count (*) from 
edw_scver_coda_accs_views.v_base_pre_advice
group by 1
order by substr(file_sub_dttm, 1, 10) desc
;

sel event_actual_date, count (*)
from edw_scver_coda_accs_views.v_shipper_piece
group by 1;

sel production_dt ,  count (*) from 
edw_scver_coda_accs_views.v_base_pre_adv_item_detail
group by 1
order by production_dt desc
;

sel production_dt, count (*) from
edw_scver_coda_accs_views.v_base_pre_advice bpa   --- sel top 10 * from edw_scver_coda_accs_views.v_base_pre_advice
inner join
edw_scver_coda_accs_views.v_base_pre_adv_item_detail  bpaid   --- sel top 10 * from edw_scver_coda_accs_views.v_base_pre_adv_item_detail
on bpaid.pre_adv_trans_id = bpa.pre_adv_trans_id
group by 1
;

show view edw_scver_bo_views.v_route;
show view edw_scver_bo_views.v_delivery_point_address;
show view edw_scver_bo_views.v_route_delivery_schedule;
show view edw_scver_coda_accs_views.v_base_mpe;
show view edw_scver_coda_accs_views.v_party_address;

sel count (*) from edw_scver_bo_views.v_delivery_point_address;
sel count (*) from edw_scver_bo_views.v_route;
sel count (*) from edw_scver_bo_views.v_location;
sel count (*) from edw_scver_coda_dim_views.v_dim_address_ops_hierarchy;
sel count (*) from edw_scver_coda_dim_views.v_dim_address;
sel count (*) from edw_scver_bo_views.v_route_delivery_schedule;
sel count (*) from  edw_scver_coda_accs_views.v_base_mpe;

sel top 10 * from edw_scver_coda_accs_views.v_party_privacy_preferences
where data_source_cd NOT IN ('KOGNITIO', 'MARS','SIEBEL');

sel top 10 * from edw_scver_coda_accs_views.v_sales_transaction_line;
sel count (*) from EDW_SCVER_CODA_ACCS_VIEWS.v_sales_transaction_line_dtls;
sel count (*) from EDW_SCVER_CODA_ACCS_VIEWS.v_sales_transaction_line_dtls where recip_email_addr is not null;

sel distinct data_source_cd from edw_scver_coda_accs_views.v_party_privacy_preferences;
