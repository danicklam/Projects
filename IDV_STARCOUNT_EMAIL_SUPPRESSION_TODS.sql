sel top 10 * from
EDW_SCVER_BO_VIEWS.V_TODS_TRACKED_PRE_ADVICE 
;


sel top 10 * from
EDW_SCVER_CODA_ACCS_VIEWS.V_SALES_TRANSACTION_LINE
;

sel count (*) from
EDW_SCVER_BO_VIEWS.V_TODS_TRACKED_PRE_ADVICE TTPA
inner join
EDW_SCVER_CODA_ACCS_VIEWS.V_SALES_TRANSACTION_LINE_DTLS stld
on stld.sales_tran_line_id = ttpa.sales_tran_line_id
and stld.recip_email_addr is not null
;


sel top 10 *  from
EDW_SCVER_BO_VIEWS.V_TODS_TRACKED_PRE_ADVICE TTPA
inner join
EDW_SCVER_CODA_ACCS_VIEWS.V_SALES_TRANSACTION_LINE_DTLS stld
on stld.sales_tran_line_id = ttpa.sales_tran_line_id
and stld.recip_email_addr is not null
;

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

drop table vt_tods_email_senders;

sel count (*) from EDW_SCVER_BO_VIEWS.V_TODS_TRACKED_PRE_ADVICE;

select distinct org_name from vt_tods_email_senders
--where substr(org_name, 1,5) = 'RIVER'
--or substr(org_name, 1,5) = 'River'
where substr(org_name, 1,1) IN ('R', 'U', 'J', 'M','4')
--where substr(org_name, 1,1) IN ('4')
;

sel distinct org_name from 
EDW_SCVER_BO_VIEWS.V_TODS_TRACKED_PRE_ADVICE
where substr(org_name, 1,1) IN ('R', 'U', 'J', 'M','4')
--where substr(org_name, 1,1) = ('4')
;


sel distinct ttpa.org_name from
EDW_SCVER_BO_VIEWS.V_TODS_TRACKED_PRE_ADVICE TTPA
inner join
EDW_SCVER_CODA_ACCS_VIEWS.V_SALES_TRANSACTION_LINE_DTLS stld
on stld.sales_tran_line_id = ttpa.sales_tran_line_id
--and stld.recip_email_addr is not null
and ttpa.org_name like '4%'
and ttpa.promised_fulfillment_dt between date'2017-09-01' and date '2017-09-30'

;



--- MARKS & SPENCER PLC
--- River Island
--- River Island Clothing Co
--- URBAN OUTFITTERS INC.

sel top 10 * from 
--edw_scver_coda_accs_views.V_PREADVICE_RECEIPT_EVENT
--edw_scver_coda_accs_views.V_POISE_SHIPPER_PIECE                                     
--edw_scver_coda_accs_views.V_POISE_CONSIGNMENT                                         
edw_scver_coda_accs_views.V_POISE_POSTAL_PIECE_EVENT    
;

drop table 
MGRS_LAM.CREDO_LIST_DATA
;