 
select event_id, event_actual_dttm, source_system
from EDW_SCVER_CODA_ACCS_VIEWS.v_delivery;
select event_id, location_id, RM_Event_Code
from EDW_SCVER_BO_VIEWS.v_bo_base_track_data_dtl;
select location_id, Location_Name_Rln
from EDW_SCVER_BO_VIEWS.v_location;
select event_id, party_id, event_actual_dt, Event_Party_Role_Id
from EDW_SCVER_CODA_ACCS_VIEWS.v_event_party;
select party_id, address_id, address_type_id 
from EDW_SCVER_CODA_ACCS_VIEWS.v_party_address;
select address_id, postcode, delivery_point_suffix_val
from EDW_SCVER_CODA_ACCS_VIEWS.v_dim_address;
select event_id, piece_id
from EDW_SCVER_BO_VIEWS.v_postal_piece_event;
sel piece_id, track_number, location_id
from EDW_SCVER_BO_VIEWS.v_bo_base_track_data;
select event_id, party_id, event_actual_dt, Event_Party_Role_Id
from EDW_SCVER_CODA_ACCS_VIEWS.v_event_party;
select party_id, address_id, address_type_id 
from EDW_SCVER_CODA_ACCS_VIEWS.v_party_address;
select address_id, postcode, delivery_point_suffix_val
from EDW_SCVER_CODA_ACCS_VIEWS.v_dim_address;
select address_id, do_name
from EDW_SCVER_CODA_DIM_VIEWS.v_dim_address_ops_hierarchy;
select er_mpe_id, event_dttm, unique_item_id, tracked_event_cd, location_id, delivery_point, delivery_point_postcode
from EDW_SCVER_CODA_ACCS_VIEWS.v_base_mpe;
select location_id, location_name_rln
from EDW_SCVER_BO_VIEWS.v_location;
select route_num, route_name, route_id, route_owner_location_id, record_status
from EDW_SCVER_BO_VIEWS.v_route;
select Delivery_Route_Id, Route_Sequence_Num, point_address_id, route_dp_del_ind
from EDW_SCVER_BO_VIEWS.v_route_delivery_schedule;
select point_address_id, Latitude_Meas latitude, Longitude_Meas longitude, Postcode, delivery_point_suffx_val 
from EDW_SCVER_BO_VIEWS.v_delivery_point_address;





show table	edw_scver.delivery;
show table	edw_scver.bo_base_track_data_dtl;
show table	edw_scver.location;
show table	edw_scver.event_party;
show table	edw_scver.party_address;
show table	edw_scver.dim_address;
show table	edw_scver.postal_piece_event;
show table	edw_scver.bo_base_track_data;
show table	edw_scver.event_party;
show table	edw_scver.party_address;
show table	edw_scver.dim_address;
show table	edw_scver.address_ops_hierarchy;
show table	edw_scver.base_mpe;
show table	edw_scver.location;
show table	edw_scver.route;
show table	edw_scver.route_delivery_schedule;
show table	edw_scver.delivery_point_address;


