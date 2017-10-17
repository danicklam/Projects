
select 
ppe.paf_udprn as UDPRN, 
trim(ppe.address_id)||lpad(cast(ppe.indiv_cluster_id as varchar(4)),4,'0000') as CLUSTER_ID, 
org.organization_name as SENDERS_NAME, 
dst.data_source_type_desc as SOURCE_SYSTEM, 
'SEPTEMBER' as "MONTH",
count (distinct ep.piece_id) as COUNT_OF_ITEMS

from EDW_SCVER_CODA_ACCS_VIEWS.v_event_party EP
inner join MgrS_LAM.BLS_PPE PPE  -- sel top 10 * from MgrS_LAM.BLS_PPE
on PPE.party_id = EP.PARTY_ID and EP.data_source_type_id IN (1,2,11) and EP.event_party_role_id = 1
and PPE.paf_udprn > 1
and ep.event_actual_dt between date '2017-09-01' and date '2017-09-30'
left join EDW_SCVER_CODA_ACCS_VIEWS.v_event_party EP2
on EP2.event_id = ep.event_id and EP2.event_party_role_id =2 and ep2.data_source_type_id = 11
left join EDW_SCVER_CODA_ACCS_VIEWS.v_organization org
on ep2.party_id = org.party_id 
inner join EDW_SCVER_CODA_ACCS_VIEWS.v_data_source_type dst ----sel top 10 * from EDW_SCVER_CODA_ACCS_VIEWS.v_data_source_type
on dst.data_source_type_id = ep.data_source_type_id
group by 1,2,3,4,5
;

select 
ppe.paf_udprn as UDPRN, 
trim(ppe.address_id)||lpad(cast(ppe.indiv_cluster_id as varchar(4)),4,'0000') as CLUSTER_ID, 
org.organization_name as SENDERS_NAME, 
dst.data_source_type_desc as SOURCE_SYSTEM, 
'AUGUST' as "MONTH",
count (distinct ep.piece_id) as COUNT_OF_ITEMS

from EDW_SCVER_CODA_ACCS_VIEWS.v_event_party EP
inner join MgrS_LAM.BLS_PPE PPE  -- sel top 10 * from MgrS_LAM.BLS_PPE
on PPE.party_id = EP.PARTY_ID and EP.data_source_type_id IN (1,2,11) and EP.event_party_role_id = 1
and PPE.paf_udprn > 1
and ep.event_actual_dt between date '2017-08-01' and date '2017-08-31'
left join EDW_SCVER_CODA_ACCS_VIEWS.v_event_party EP2
on EP2.event_id = ep.event_id and EP2.event_party_role_id =2 and ep2.data_source_type_id = 11
left join EDW_SCVER_CODA_ACCS_VIEWS.v_organization org
on ep2.party_id = org.party_id 
inner join EDW_SCVER_CODA_ACCS_VIEWS.v_data_source_type dst ----sel top 10 * from EDW_SCVER_CODA_ACCS_VIEWS.v_data_source_type
on dst.data_source_type_id = ep.data_source_type_id
group by 1,2,3,4,5
;

select 
ppe.paf_udprn as UDPRN, 
trim(ppe.address_id)||lpad(cast(ppe.indiv_cluster_id as varchar(4)),4,'0000') as CLUSTER_ID, 
org.organization_name as SENDERS_NAME, 
dst.data_source_type_desc as SOURCE_SYSTEM, 
'JULY' as "MONTH",
count (distinct ep.piece_id) as COUNT_OF_ITEMS

from EDW_SCVER_CODA_ACCS_VIEWS.v_event_party EP
inner join MgrS_LAM.BLS_PPE PPE  -- sel top 10 * from MgrS_LAM.BLS_PPE
on PPE.party_id = EP.PARTY_ID and EP.data_source_type_id IN (1,2,11) and EP.event_party_role_id = 1
and PPE.paf_udprn > 1
and ep.event_actual_dt between date '2017-07-01' and date '2017-07-31'
left join EDW_SCVER_CODA_ACCS_VIEWS.v_event_party EP2
on EP2.event_id = ep.event_id and EP2.event_party_role_id =2 and ep2.data_source_type_id = 11
left join EDW_SCVER_CODA_ACCS_VIEWS.v_organization org
on ep2.party_id = org.party_id 
inner join EDW_SCVER_CODA_ACCS_VIEWS.v_data_source_type dst ----sel top 10 * from EDW_SCVER_CODA_ACCS_VIEWS.v_data_source_type
on dst.data_source_type_id = ep.data_source_type_id
group by 1,2,3,4,5
;

select 
ppe.paf_udprn as UDPRN, 
trim(ppe.address_id)||lpad(cast(ppe.indiv_cluster_id as varchar(4)),4,'0000') as CLUSTER_ID, 
org.organization_name as SENDERS_NAME, 
dst.data_source_type_desc as SOURCE_SYSTEM, 
'JUNE' as "MONTH",
count (distinct ep.piece_id) as COUNT_OF_ITEMS

from EDW_SCVER_CODA_ACCS_VIEWS.v_event_party EP
inner join MgrS_LAM.BLS_PPE PPE  -- sel top 10 * from MgrS_LAM.BLS_PPE
on PPE.party_id = EP.PARTY_ID and EP.data_source_type_id IN (1,2,11) and EP.event_party_role_id = 1
and ep.event_actual_dt between date '2017-06-01' and date '2017-06-30'
left join EDW_SCVER_CODA_ACCS_VIEWS.v_event_party EP2
on EP2.event_id = ep.event_id and EP2.event_party_role_id =2 and ep2.data_source_type_id = 11
left join EDW_SCVER_CODA_ACCS_VIEWS.v_organization org
on ep2.party_id = org.party_id 
inner join EDW_SCVER_CODA_ACCS_VIEWS.v_data_source_type dst ----sel top 10 * from EDW_SCVER_CODA_ACCS_VIEWS.v_data_source_type
on dst.data_source_type_id = ep.data_source_type_id
group by 1,2,3,4,5
;

select 
ppe.paf_udprn as UDPRN, 
trim(ppe.address_id)||lpad(cast(ppe.indiv_cluster_id as varchar(4)),4,'0000') as CLUSTER_ID, 
org.organization_name as SENDERS_NAME, 
dst.data_source_type_desc as SOURCE_SYSTEM, 
'MAY' as "MONTH",
count (distinct ep.piece_id) as COUNT_OF_ITEMS

from EDW_SCVER_CODA_ACCS_VIEWS.v_event_party EP
inner join MgrS_LAM.BLS_PPE PPE  -- sel top 10 * from MgrS_LAM.BLS_PPE
on PPE.party_id = EP.PARTY_ID and EP.data_source_type_id IN (1,2,11) and EP.event_party_role_id = 1
and ep.event_actual_dt between date '2017-05-01' and date '2017-05-31'
left join EDW_SCVER_CODA_ACCS_VIEWS.v_event_party EP2
on EP2.event_id = ep.event_id and EP2.event_party_role_id =2 and ep2.data_source_type_id = 11
left join EDW_SCVER_CODA_ACCS_VIEWS.v_organization org
on ep2.party_id = org.party_id 
inner join EDW_SCVER_CODA_ACCS_VIEWS.v_data_source_type dst ----sel top 10 * from EDW_SCVER_CODA_ACCS_VIEWS.v_data_source_type
on dst.data_source_type_id = ep.data_source_type_id
group by 1,2,3,4,5
;

/*
WORKING EXTRACT QUERY
*/

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
select 
distinct org.organization_name
--ppe.paf_udprn as UDPRN, 
--trim(ppe.address_id)||lpad(cast(ppe.indiv_cluster_id as varchar(4)),4,'0000') as CLUSTER_ID, 
--org.organization_name as SENDERS_NAME, 
--dst.data_source_type_desc as SOURCE_SYSTEM, 
--'APRIL' as "MONTH",
--count (distinct ep.piece_id) as COUNT_OF_ITEMS

from EDW_SCVER_CODA_ACCS_VIEWS.v_event_party EP
inner join MgrS_LAM.BLS_PPE PPE  -- sel top 10 * from MgrS_LAM.BLS_PPE
on PPE.party_id = EP.PARTY_ID and EP.data_source_type_id IN (5) and EP.event_party_role_id = 1
and PPE.paf_udprn > 1
and ep.event_actual_dt between date '2017-04-01' and date '2017-09-30'
left join EDW_SCVER_CODA_ACCS_VIEWS.v_event_party EP2
on EP2.event_id = ep.event_id and EP2.event_party_role_id =2 and ep2.data_source_type_id IN (5)
left join EDW_SCVER_CODA_ACCS_VIEWS.v_organization org
on ep2.party_id = org.party_id 
inner join EDW_SCVER_CODA_ACCS_VIEWS.v_data_source_type dst ----sel top 10 * from EDW_SCVER_CODA_ACCS_VIEWS.v_data_source_type
on dst.data_source_type_id = ep.data_source_type_id
and substr(org.organization_name ,1,1) IN ('R','M','U','J') 
--group by 1,2,3,4,5
;

---  M&S
--- MARKS & SPENCER PLC
---- MARKS AND SPENCER





*/
