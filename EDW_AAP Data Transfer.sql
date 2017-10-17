/* Sub-selection of v_Individuals Table */
SEL * FROM EDW_SCVER_CODA_ACCS_VIEWS.v_individual 
WHERE EXISTS
(
SEL * from EDW_SCVER_CODA_ACCS_VIEWS.v_party_address 
where v_party_address.address_type_id in (2,3)
and v_individual.party_id = v_party_address.party_id
);

/* Sub-selection of v_party_address table - 179,437,704 */

SEL * from EDW_SCVER_CODA_ACCS_VIEWS.v_party_address 
where v_party_address.address_type_id in (2,3);

/* ALL OF V_DIM_ADDRESS - 37,781,843 */

SEL * FROM 
EDW_SCVER_CODA_ACCS_VIEWS.v_dim_address;


/* All of v_electronic_address - 31,209,771 */

SEL * FROM 
EDW_SCVER_CODA_ACCS_VIEWS. v_electronic_address;

/* All of v_telephonic_address - 37,989,578 */

SEL * FROM 
EDW_SCVER_CODA_ACCS_VIEWS. v_telephonic_address;

/*  COUNTS  */

/* Sub-selection of v_Individuals Table */
SEL count(*) FROM EDW_SCVER_CODA_ACCS_VIEWS.v_individual 
WHERE EXISTS
(
SEL * from EDW_SCVER_CODA_ACCS_VIEWS.v_party_address 
where v_party_address.address_type_id in (2,3)
and v_individual.party_id = v_party_address.party_id
);

/* Sub-selection of v_party_address table */

SEL count(*) from EDW_SCVER_CODA_ACCS_VIEWS.v_party_address 
where v_party_address.address_type_id in (2,3);

/* ALL OF V_DIM_ADDRESS */

SEL count(*) FROM 
EDW_SCVER_CODA_ACCS_VIEWS.v_dim_address;


/* All of v_electronic_address */

SEL count(*) FROM 
EDW_SCVER_CODA_ACCS_VIEWS. v_electronic_address;

/* All of v_telephonic_address */

SEL count(*) FROM 
EDW_SCVER_CODA_ACCS_VIEWS. v_telephonic_address;