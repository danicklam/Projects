
/*

I’ve just reviewed the data sharing agreement and we can extract the following under the current agreement:
 
-          All SW6 post codes in the attached list
-          Date range of last 3 months
-          Party ID
-          Cluster ID
-          First name
-          Surname
 
As discussed forget the traffic volumes. But would it be possible to have the “source system” included? 
This is so as we know if it came from a parcels (little “p”) system or letters. If not don’t worry. 
Please can wel have the SW6 data ready today?
 
Then the second extract will be on all the other post codes in here once I’ve got the data sharing agreement amended. 
I’ll let you know when that is but I am hoping for it to be done today. 
And also as discussed if the post codes with building names are too tough to figure out between names and numbers, just take them off the list. 
But please do let me know which have been extracted and which haven’t.
 
*/

sel count (*) from MGRS_LAM.ADDRESS_GRP_KEY;

create table MGRS_LAM.ADDRESS_GRP_KEY as
(
sel address_id from edw_scver_coda_dim_views.v_dim_address
where address_grpng_key IN (
2750765,
3820576,
7695207,
10993586,
11098076,
11098077,
11098078,
11098079,
11098080,
11098081,
11098082,
11098083,
11098084,
11098085,
11098086,
11098087,
11098088,
11098089,
11098090,
11098091,
11098092,
11098093,
11098094,
11098095,
11098096,
11098097,
11098098,
11098099,
11098100,
11098101,
11098102,
11098103,
11098104,
11098105,
11098106,
11098107,
11098108,
11098109,
11098110,
11098111,
11098112,
11098113,
11098114,
11098115,
11098116,
11098117,
11098118,
11098119,
11098120,
11098121,
11098122,
11098123,
11098124,
11098125,
11098126,
11098127,
11098128,
11098129,
11098130,
11098131,
11098132,
11098133,
11098134,
11098135,
11098136,
11098137,
11098138,
11098139,
11098140,
11098141,
11098142,
11098143,
11098144,
11098145,
11098146,
11098147,
15973504,
22865505,
23539899,
23702033,
27631896,
28234622,
28236934,
28818619,
30470882,
30470882,
30580763,
30670528,
30710901,
30722578,
30873138,
30895445,
30898277,
30898429,
30899387,
30899387,
30899387,
30899387,
30899391,
30899392,
30899392,
30899392,
30899394,
30899395,
30899396,
30899396,
30899396,
30899398,
30899399,
30899399,
30899400,
30899401,
30899402,
30899402,
30899402,
30899404,
30899404,
30899404,
30899406,
30899406,
30899406,
30899408,
30899408,
30899410,
30899410,
30899412,
30899413,
30899414,
30899415,
32655548,
32656676,
32716166,
32742289,
33230317,
33234780,
33239418,
33240916,
35656183,
36554895,
36554895,
36554895,
36554895,
36554895,
36554900,
36554901,
36554902,
36554902,
36554904,
36554905,
36554905,
36554905,
36554908,
36554908,
36554910,
36554911
)
)
 with data
;


sel pa.party_id, pa.address_id||' '||ind.indiv_cluster_id, ind.forename, ind.lastname, psd.data_source_cd, da.*
from edw_scver_coda_accs_views.v_party_address pa
inner join MGRS_LAM.ADDRESS_GRP_KEY mgrs
on mgrs.address_id = pa.address_id
inner join edw_scver_coda_dim_views.v_dim_address da
on pa.address_id = da.address_id
and pa.address_type_id = 1
inner join edw_scver_coda_accs_views.v_individual ind   --- sel top 10* from edw_scver_coda_accs_views.v_individual
on ind.party_id = pa.party_id
and ind.indiv_cluster_id is not null
inner join edw_scver_coda_accs_views.v_party_source_dtl psd --- sel top 10 * from edw_scver_coda_accs_views.v_party_source_dtl
on psd.party_id = pa.party_id
inner join edw_scver_coda_accs_views.v_event_party ep
on ep.party_id = pa.party_id
and ep.event_actual_dt between date '2017-07-01' and date '2017-10-11'
;


/*
sel * from
edw_scver_coda_dim_views.v_dim_address 
where postcode = 'SW6 2UZ'
where address_grpng_key IN
(
3820576,
33230317,
)
*/
