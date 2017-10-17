sel 
'CODA_ACCS_VIEWS.v_event_party' as table_name_in_full_long_xxxx, count (*) as count_N from 
EDW_SCVER_CODA_ACCS_VIEWS.v_event_party where event_actual_dt > date '2015-01-01'  and data_source_type_id in (1, 2, 11) and Event_Party_Role_Id = 1
union select 
'BO_VIEWS.v_bo_base_track_data' as table_name_in_full_long_xxxx, count (*) as count_N from
EDW_SCVER_BO_VIEWS.v_bo_base_track_data
union
sel 'BO_VIEWS.v_bo_base_track_data_dtl' as table_name_in_full_long_xxxx,count (*) as count_N from
EDW_SCVER_BO_VIEWS.v_bo_base_track_data_dtl
union
sel 'CODA_ACCS_VIEWS.v_party_address' as table_name_in_full_long_xxxx, count (*) as count_N from 
EDW_SCVER_CODA_ACCS_VIEWS.v_party_address
union
sel 'CODA_ACCS_VIEWS.v_delivery' as table_name_in_full_long_xxxx, count (*) as count_N from 
EDW_SCVER_CODA_ACCS_VIEWS.v_delivery
union
sel 'CODA_ACCS_VIEWS.v_base_mpe' as table_name_in_full_long_xxxx, count (*) as count_N from 
EDW_SCVER_CODA_ACCS_VIEWS.v_base_mpe
union
sel 'BO_VIEWS.v_route_delivery_schedule' as table_name_in_full_long_xxxx, count (*) as count_N from
EDW_SCVER_BO_VIEWS.v_route_delivery_schedule
union
sel 'CODA_DIM_VIEWS.v_dim_address' as table_name_in_full_long_xxxx, count (*) as count_N from
EDW_SCVER_CODA_DIM_VIEWS.v_dim_address
union
sel 'CODA_DIM_VIEWS.v_dim_address_ops_hierarchy' as table_name_in_full_long_xxxx, count (*) as count_N from
EDW_SCVER_CODA_DIM_VIEWS.v_dim_address_ops_hierarchy
union
sel 'BO_VIEWS.v_delivery_point_address' as table_name_in_full_long_xxxx, count (*) as count_N from
EDW_SCVER_BO_VIEWS.v_delivery_point_address 
union 
sel 'BO_VIEWS.v_route' as table_name_in_full_long_xxxx, count (*)as count_N from
EDW_SCVER_BO_VIEWS.v_route
union
sel 'BO_VIEWS.v_location' as table_name_in_full_long_xxxx, count (*) as count_N from
EDW_SCVER_BO_VIEWS.v_location; 
 


sel top 10 * from edw_scver_coda_accs_views.v_base_mpe;
 
 select er_mpe_id, event_dttm, unique_item_id, tracked_event_cd, location_id, delivery_point, 
 delivery_point_postcode from edw_scver_coda_accs_views.v_base_mpe where er_dttm  
 between (current_date - 7)  and current_date;
 
 
  sel top 10 * from edw_scver_bo_views.v_bo_base_track_data;
  
  select piece_id, track_number, location_id from edw_scver_bo_views.v_bo_base_track_data where scan_date between (current_date - 7) and current_date;
  
  
    sel top 10 * from edw_scver_bo_views.v_bo_base_track_data_dtl;
    
    select event_id, location_id, RM_Event_Code from edw_scver_bo_views.v_bo_base_track_data_dtl where event_actual_date between (current_date -7) and current_date;
 
    sel top 10 * from edw_scver_bo_views.v_delivery where event_actual_date between (current_date -7) and current_date;
    
    
    sel top 10 * from edw_scver_bo_views.v_delivery_point_address;
    
    select current_date, point_address_id, Latitude_Meas, Longitude_Meas, Postcode, delivery_point_suffx_val from edw_scver_bo_views.v_delivery_point_address;
    
    
    sel top 10 * from edw_scver_coda_accs_views.v_party_address;
    
    select party_id, address_id, address_type_id from edw_scver_coda_accs_views.v_party_address where scver_upd_dttm between (current_date - 7) and current_date;
    
    
select count (*) from edw_scver_bo_views.v_bo_base_track_data_dtl;  
select count (*) from edw_scver_bo_views.v_bo_base_track_data;  
select count (*) from edw_scver_coda_accs_views.v_event_party; 
select count (*) from edw_scver_coda_accs_views.v_party_address; 
    
show view edw_scver_bo_views.v_bo_base_track_data_dtl;
show view edw_scver_bo_views.v_bo_base_track_data;
show view edw_scver_coda_accs_views.v_base_mpe;
show view edw_scver_coda_accs_views.v_party_address;
show view edw_scver_coda_accs_views.v_delivery;
show view edw_scver_coda_accs_views.v_event_party;
show view edw_scver_coda_bo_views.v_event_party;
show view edw_scver_bo_views.v_route;

show table edw_scver.bo_base_track_data_dtl;
show table edw_scver.base_mpe; -- barcode_creation_dt
show table edw_scver.party_address;
show table edw_scver.delivery;
show table edw_scver.event_party;
    
sel count (*) from edw_scver_coda_bo_views.v_event_party;
    
    

sel walk_delivery_date, count (*) from
edw_scver_coda_accs_views.v_delivery
where walk_delivery_date > date '2017-09-01'
group by 1
;


sel top 10 * from 
edw_scver_coda_accs_views.v_party_address;

select count (*) 
from edw_scver_coda_accs_views.v_delivery where walk_delivery_date 
between (current_date - 7) and current_date;
