--1
--A
create table a6_lrs
(
    geom sdo_geometry
);

--B
insert into a6_lrs 
select sr.geom
from streets_and_railroads sr, major_cities mc
where SDO_RELATE(sr.geom, SDO_GEOM.SDO_BUFFER(mc.geom, 10, 1, 'unit=km'), 'MASK=ANYINTERACT') = 'TRUE'
and mc.city_name = 'Koszalin';

--C
select SDO_GEOM.SDO_LENGTH(geom, 1, 'unit=km') as distance,
ST_LINESTRING(geom).ST_NUMPOINTS() as st_numpoints
from a6_lrs;

--D
update a6_lrs
set geom = SDO_LRS.CONVERT_TO_LRS_GEOM(geom, 0, sdo_geom.sdo_length(geom, 1, 'unit=km'));

--E
insert into USER_SDO_GEOM_METADATA
values ('A6_LRS', 
    'GEOM',
    MDSYS.SDO_DIM_ARRAY(
        MDSYS.SDO_DIM_ELEMENT('X', 12.603676, 26.369824, 1),
        MDSYS.SDO_DIM_ELEMENT('Y', 45.8464, 58.0213, 1),
        MDSYS.SDO_DIM_ELEMENT('M', 0, 300, 1)),
    8307);

--F
create index a6_lrs_idx
on a6_lrs(geom) 
indextype is MDSYS.SPATIAL_INDEX;

--2
--A
select SDO_LRS.VALID_MEASURE(geom, 500) as valid_500
from a6_lrs;

--B
select SDO_LRS.GEOM_SEGMENT_END_PT(geom) as end_pt
from a6_lrs;

--C
select SDO_LRS.LOCATE_PT(geom, 150) as km100 
from a6_lrs;

--D
select SDO_LRS.CLIP_GEOM_SEGMENT(geom, 120, 160)  as clipped
from a6_lrs;

--E
select SDO_LRS.GET_NEXT_SHAPE_PT(a6.geom, SDO_LRS.PROJECT_PT(a6.geom, mc.geom)) as wjazd_na_a6
from a6_lrs a6, major_cities mc where mc.city_name = 'Slupsk';

--F
select SDO_GEOM.SDO_LENGTH(
    SDO_LRS.OFFSET_GEOM_SEGMENT(
    a6.geom, m.diminfo, 50, 200, 50,'unit=m arc_tolerance=0,05'),
1, 'unit=km') as koszt
from a6_lrs a6,
user_sdo_geom_metadata m
where m.table_name = 'A6_LRS'
and m.column_name = 'GEOM';