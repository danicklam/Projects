sel 'EDW_SCVER_BO_VIEWS.v_delivery_point_address' as table_name, count (*) from	EDW_SCVER_BO_VIEWS.v_delivery_point_address
UNION sel 'EDW_SCVER_BO_VIEWS.v_location' as table_name, count (*) from	EDW_SCVER_BO_VIEWS.v_location
UNION sel 'EDW_SCVER_BO_VIEWS.v_route' as table_name, count (*) from	EDW_SCVER_BO_VIEWS.v_route
UNION sel 'EDW_SCVER_BO_VIEWS.v_route_delivery_schedule' as table_name, count (*) from	EDW_SCVER_BO_VIEWS.v_route_delivery_schedule
UNION sel 'EDW_SCVER_BO_VIEWS.v_bo_base_track_data' as table_name, count(*) from EDW_SCVER_BO_VIEWS.v_bo_base_track_data
UNION sel 'EDW_SCVER_BO_VIEWS.v_bo_base_track_data_dtl' as table_name, count(*) from EDW_SCVER_BO_VIEWS.v_bo_base_track_data_dtl
UNION sel 'EDW_SCVER_BO_VIEWS.v_postal_piece_event' as table_name, count(*)	from EDW_SCVER_BO_VIEWS.v_postal_piece_event
UNION sel 'EDW_SCVER_BO_VIEWS.v_base_mpe' as table_name, count(*)	from EDW_SCVER_CODA_ACCS_VIEWS.v_base_mpe
UNION sel 'EDW_SCVER_CODA_ACCS_VIEWS.v_delivery' as table_name, count(*)	from EDW_SCVER_CODA_ACCS_VIEWS.v_delivery
UNION sel 'EDW_SCVER_CODA_ACCS_VIEWS.v_dim_address' as table_name, count(*)	from EDW_SCVER_CODA_ACCS_VIEWS.v_dim_address
UNION sel 'EDW_SCVER_CODA_ACCS_VIEWS.v_event_party' as table_name, count(*)	from EDW_SCVER_CODA_ACCS_VIEWS.v_event_party
UNION sel 'EDW_SCVER_CODA_ACCS_VIEWS.v_party_address' as table_name, count(*)	from EDW_SCVER_CODA_ACCS_VIEWS.v_party_address
UNION sel 'EDW_SCVER_CODA_DIM_VIEWS.v_dim_address_ops_hierarchy' as table_name, count(*)	from EDW_SCVER_CODA_DIM_VIEWS.v_dim_address_ops_hierarchy
;