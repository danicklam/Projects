

/*   COUNTS
  sel count (*) from edw_scver_coda_accs_views.v_dim_address
  where postcode_area IN ('B','LS','SN'); -- 1,713,577
  
  
  select count (*)
  from edw_scver_coda_accs_views.v_party_address pa
  inner join edw_scver_coda_accs_views.v_dim_address da
  on da.address_id = pa.address_id
  and da.postcode_area IN ('B','LS','SN'); --- 50,149,746
  
  */
  
  
  /* EXTRACT */
   sel * from edw_scver_coda_accs_views.v_dim_address
  where postcode_area IN 
  (
  --'B'
  --'LS'
  'SN'
  ); -- 1,713,577
  
  
  select distinct pa.party_id, pa.address_id, pa.address_type_id
  from edw_scver_coda_accs_views.v_party_address pa
  inner join edw_scver_coda_accs_views.v_dim_address da
  on da.address_id = pa.address_id
  and pa.address_type_id = 1
  and da.postcode_area IN ('B','LS','SN');
  

  select distinct pa.party_id, pa2.address_id, pa2.address_type_id
  from edw_scver_coda_accs_views.v_party_address pa
  inner join edw_scver_coda_accs_views.v_dim_address da
  on da.address_id = pa.address_id
  and pa.address_type_id = 1
  and da.postcode_area IN ('B','LS','SN')
  inner join edw_scver_coda_accs_views.v_party_address pa2
  on pa.party_id = pa2.party_id
  and pa2. address_type_id = 2
  ;
  
  
  select distinct pa.party_id, pa2.address_id, pa2.address_type_id
  from edw_scver_coda_accs_views.v_party_address pa
  inner join edw_scver_coda_accs_views.v_dim_address da
  on da.address_id = pa.address_id
  and pa.address_type_id = 1
  and da.postcode_area IN ('B','LS','SN')
  inner join edw_scver_coda_accs_views.v_party_address pa2
  on pa.party_id = pa2.party_id
  and pa2. address_type_id = 3
  ;