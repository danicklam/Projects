/*
1.	Count of distinct email addresses in total
2.	Count of unique clusters with any email attached to any party
3.	Count of unique clusters where we have an email_address from a source other than TODS (and no TODS)
4.	For a week of your choosing, count the number of parties that had a TODS transaction. What % did not have an email address for that transaction/party.
5.	Count of unique clusters where we have a TODS transaction (not just from the tods source) and no email address
6.	Of those clusters from #4 above, how many do we have an email address from another source. E.g if we have a parcel TODS transaction for Robert Kent but no email address, do we have an email address for Robert Kent from somewhere else in that cluster ?
*/

----- Q1.  Count of distinct email addresses in total

sel count (*) from 
edw_scver_coda_accs_views.v_electronic_address
; --- 44,196,727
sel electronic_address, count (*) from 
edw_scver_coda_accs_views.v_electronic_address
group by 1
; --- 44,196,727

----- Q2. Count of unique clusters with any email attached to any party

sel 
count (
distinct (pa.address_id||' '||ind.indiv_cluster_id)) 
from edw_scver_coda_accs_views.v_individual ind --- sel top 10* from edw_scver_coda_accs_views.v_individual
inner join edw_scver_coda_accs_views.v_party_address pa
on pa.party_id = ind.party_id
and pa.address_type_id = 2   
and ind.indiv_cluster_id is not null
inner join
edw_scver_coda_accs_views.v_electronic_address ea
on pa.address_id = ea.electronic_address_id
; --- 57,004,427 number of clusters with an email


---- Q3. Count of unique clusters where we have an email_address from a source other than TODS (and no TODS)

sel 
count (
distinct (pa.address_id||' '||ind.indiv_cluster_id)) 
from edw_scver_coda_accs_views.v_individual ind --- sel top 10* from edw_scver_coda_accs_views.v_individual
inner join edw_scver_coda_accs_views.v_party_address pa
on pa.party_id = ind.party_id
and pa.address_type_id = 2
and ind.indiv_cluster_id is not null
inner join
edw_scver_coda_accs_views.v_electronic_address ea
on pa.address_id = ea.electronic_address_id
inner join
edw_scver_coda_accs_views.v_party_source_dtl psd --- sel top 10* from edw_scver_coda_accs_views.v_party_source_dtl
on psd.party_id = ind.party_id
and psd.data_source_cd <> 'TODS'
and psd.address_type_id = 2
;

---- 25,398,590 clusters
 

---- Q4. For a week of your choosing, count the number of parties that had a TODS transaction. 
---- What % did not have an email address for that transaction/party.


sel count (distinct pa.party_id), count (distinct event_id) from 
edw_scver_coda_accs_views.v_event_party ep
inner join edw_scver_coda_accs_views.v_party_address pa
on pa.party_id = ep.party_id
and pa.address_type_id = 1
and ep.data_source_type_id = 2       ---- sel * from edw_scver_coda_accs_views.v_data_source_type
and ep.event_actual_dt between date '2017-09-20' and date '2017-09-27'
;  
--- 3,736,610 PARTIES,  4,095,178 events for TODS

sel count (distinct pa.party_id), count (distinct event_id) from 
edw_scver_coda_accs_views.v_event_party ep
inner join edw_scver_coda_accs_views.v_party_address pa
on pa.party_id = ep.party_id
and pa.address_type_id = 1
and ep.data_source_type_id = 2
and ep.event_actual_dt between date '2017-09-20' and date '2017-09-27'
inner join edw_scver_coda_accs_views.v_SALES_TRANSACTION_LINE stl
on stl.piece_id = ep.piece_id
inner join edw_scver_coda_accs_views.v_sales_transaction_line_dtls  stld  --- sel top 10 * from edw_scver_coda_accs_views.v_sales_transaction_line_dtls
on stl.Sales_Tran_Line_Id = stld.Sales_Tran_Line_Id
inner join EDW_SCVER_BO_VIEWS.V_TODS_TRACKED_PRE_ADVICE  ttpa
on stld.sales_tran_line_id = ttpa.sales_tran_line_id
and stld.recip_email_addr is not null
;    
--- 1,678,802 Parties, 1,713,448 EVENTS WITH NO EMAILS



---- Q5. Count of unique clusters where we have a TODS transaction 
----     (not just from the tods source) and no email address

sel count (distinct (pa.party_id||' '||ind.indiv_cluster_id)), count (distinct event_id) from 
edw_scver_coda_accs_views.v_event_party ep
inner join edw_scver_coda_accs_views.v_party_address pa
on pa.party_id = ep.party_id
and pa.address_type_id = 1
and ep.data_source_type_id = 2
inner join edw_scver_coda_accs_views.v_individual ind
on ind.party_id = pa.party_id
and ind.indiv_cluster_id is not null
and NOT EXISTS (
SEL pa2.party_id from edw_scver_coda_accs_views.v_party_address pa2
where pa2.party_id = ep.party_id 
and pa2.address_type_id = 2);


-----  46,061,327 Clusters with no emails from TODS Transactions
-----  103,531,460 Events with no emails from TODS Transactions



---- Q6. Of those clusters from #4 above, how many do we have an email address from another source.
----     E.g if we have a parcel TODS transaction for Robert Kent but no email address. 
----     Do we have an email address for Robert Kent from somewhere else in that cluster ?

sel count (distinct pa.party_id||' '||indiv_cluster_id), count (distinct event_id) from 
edw_scver_coda_accs_views.v_event_party ep
inner join edw_scver_coda_accs_views.v_party_address pa
on pa.party_id = ep.party_id
and pa.address_type_id = 1
and ep.data_source_type_id = 2
and ep.event_actual_dt between date '2017-09-20' and date '2017-09-27'
inner join edw_scver_coda_accs_views.v_individual ind
on ind.party_id = pa.party_id
and ind.indiv_cluster_id is not null
inner join edw_scver_coda_accs_views.v_SALES_TRANSACTION_LINE stl
on stl.piece_id = ep.piece_id
inner join edw_scver_coda_accs_views.v_sales_transaction_line_dtls  stld  --- sel top 10 * from edw_scver_coda_accs_views.v_sales_transaction_line_dtls
on stl.Sales_Tran_Line_Id = stld.Sales_Tran_Line_Id
inner join EDW_SCVER_BO_VIEWS.V_TODS_TRACKED_PRE_ADVICE  ttpa
on stld.sales_tran_line_id = ttpa.sales_tran_line_id
and stld.recip_email_addr is null
inner join EDW_SCVER_CODA_ACCS_VIEWS.V_PARTY_ADDRESS PA2
ON PA2.party_Id = ind.party_id
AND PA2.ADDRESS_TYPE_ID =2
;

----- 658,153 Clusters that can be assocaited with an email from another source
----- 877,404 Events That can be associated with an email from another source


