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
 -- sel top 10 * from edw_scver_coda_accs_views.v_shipper_piece

sel count (*) from (
sel ep.party_id, ppe.paf_udprn, ppe.address_id, ppe.indiv_cluster_id, org.organization_name, 'PARCELS' as Source, count (distinct ep.piece_id) as piece_count
from EDW_SCVER_CODA_ACCS_VIEWS.v_event_party EP
inner join MgrS_LAM.BLS_PPE PPE  -- sel top 10 * from MgrS_LAM.BLS_PPE
on PPE.party_id = EP.PARTY_ID and EP.data_source_type_id IN ( 1,2,11) and EP.event_party_role_id = 1
and ep.event_actual_dt between date '2017-04-01' and date '2017-04-30'
left join EDW_SCVER_CODA_ACCS_VIEWS.v_event_party EP2
on EP2.event_id = ep.event_id and EP2.event_party_role_id =2 and ep2.data_source_type_id = 11
left join EDW_SCVER_CODA_ACCS_VIEWS.v_organization org
on ep2.party_id = org.party_id 
group by 1,2,3,4,5,6
)x
;

sel count (distinct address_id||'_'||indiv_cluster_id) from MgrS_LAM.BLS_PPE;
sel count (distinct postcode) from EDW_SCVER_CODA_DIM_VIEWS.v_dim_address
where postcode_area IN ('SN', 'LS', 'B');

sel distinct (postcode) from EDW_SCVER_CODA_DIM_VIEWS.v_dim_address
where postcode_area IN ('SN', 'LS', 'B');

sel count (distinct (PAF_UDPRN)) from EDW_SCVER_CODA_DIM_VIEWS.v_dim_address
where postcode_area IN ('SN', 'LS', 'B');


sel ep.party_id, organization_name, count (distinct piece_id) from EDW_SCVER_CODA_ACCS_VIEWS.v_event_party ep
inner join EDW_SCVER_CODA_ACCS_VIEWS.v_organization org   --sel top 10 * from EDW_SCVER_CODA_ACCS_VIEWS.v_organization
on ep.party_id = org.party_id
and ep.event_party_role_id = 2 and ep.data_source_type_id = 11
and ep.event_actual_dt between date '2017-09-01' and date '2017-09-30'
group by 1,2
;


sel data_source_type_id, count(distinct piece_id) from edw_scver_coda_accs_views.v_event_party
where event_actual_dt between (current_date - 30) and current_date 
and data_source_type_id = 1
and event_party_role_id = 1
group by 1
UNION sel data_source_type_id, count(distinct piece_id)  from edw_scver_coda_accs_views.v_event_party
where event_actual_dt between (current_date - 30) and current_date 
and data_source_type_id = 2
and event_party_role_id = 1
group by 1
UNION sel data_source_type_id, count(distinct piece_id) from edw_scver_coda_accs_views.v_event_party
where event_actual_dt between (current_date - 30) and current_date 
and data_source_type_id = 11
and event_party_role_id = 1
group by 1
;


sel top 10 * from edw_scver_coda_accs_views.v_event_party;

/* RMGTT */
select 
ppe.paf_udprn as UDPRN, 
trim(ppe.address_id)||lpad(cast(ppe.indiv_cluster_id as varchar(4)),4,'0000') as CLUSTER_ID, 
'' as SENDERS_NAME, 
dst.data_source_type_desc as SOURCE_SYSTEM, 
'APRIL' as "MONTH"
--,count (distinct ep.piece_id) as COUNT_OF_ITEMS

from EDW_SCVER_CODA_ACCS_VIEWS.v_event_party EP -- sel top 10 * from EDW_SCVER_CODA_ACCS_VIEWS.v_event_party where data_source_type_id = 1
inner join MgrS_LAM.BLS_PPE PPE  -- sel top 10 * from MgrS_LAM.BLS_PPE
on PPE.party_id = EP.PARTY_ID and EP.data_source_type_id IN (1) and EP.event_party_role_id = 1
and PPE.paf_udprn > 1
and ep.event_actual_dt between date '2017-04-01' and date '2017-04-30'
inner join EDW_SCVER_CODA_ACCS_VIEWS.v_data_source_type dst ----sel top 10 * from EDW_SCVER_CODA_ACCS_VIEWS.v_data_source_type
on dst.data_source_type_id = ep.data_source_type_id
--group by 1,2,3,4,5
;


sel top 10 * 
from EDW_SCVER_CODA_ACCS_VIEWS.v_event_party EP 
inner join edw_scver_coda_accs_views.v_individual P
on P.party_id = EP.PARTY_ID
and EP.data_source_type_id IN (1) and EP.event_party_role_id = 1
and ep.event_actual_dt between date '2017-04-01' and date '2017-04-30'
;


sel top 10 * from edw_scver_coda_accs_views.v_individual;
