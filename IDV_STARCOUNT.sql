sel top 10 * from 
edw_scver_coda_accs_views.v_base_mpe;

sel top 10 * from 
edw_scver_coda_accs_views.v_base_pre_advice;


sel top 10 * from 
edw_scver_coda_accs_views.v_base_pre_advice
where sender_name = '%SPORTS%';


sel top 10 * from
edw_scver_coda_accs_views.v_poise_shipper_piece;

sel top 10 * from
EDW_SCVER_CODA_ACCS_VIEWS.v_pcl_ana_rep
;
sel distinct sender_name from
EDW_SCVER_CODA_ACCS_VIEWS.v_base_pre_advice
;


sel top 10 * from
edw_scver_coda_accs_views.v_poise_consignment;

sel top 10 * from
EDW_SCVER_CODA_ACCS_VIEWS.v_poise_postal_piece_event;

sel top 10 * from 
EDW_SCVER_CODA_ACCS_VIEWS.v_sales_transaction_line;

sel top 100 * from 
EDW_SCVER_CODA_ACCS_VIEWS.v_sales_transaction_line_DTLS
where business_name is not null;

sel top 100 * from 
EDW_SCVER_CODA_ACCS_VIEWS.v_shipper_piece;

show table edw_scver.base_mpe;

select barcode_creation_dt, count (*) from edw_scver_bo_views.v_base_mpe
group by 1;

show table EDW_SCVER.BASE_MPE_HIST;


sel top 10 * from edw_scver_coda_accs_views.v_base_mpe;
sel top 10 * from edw_scver_coda_accs_views.v_base_pre_adv_item_detail;

sel top 10 * from edw_scver_coda_accs_views.v_shipper_piece
where source_system = 'PARCELS';

sel event_actual_dt, data_source_type_id, count (*) from edw_scver_coda_accs_views.v_event_party
where event_actual_dt between date '2017-05-01' and date '2017-07-31'
group by 1,2;

sel top 10 * from edw_scver_coda_accs_views.v_event_party
where data_source_type_id = 11;


sel top 10 
er_mpe_id, unique_mail_id, mail_piece_id, unique_item_id from edw_scver_bo_views.v_base_mpe;