--1
--A
insert into USER_SDO_GEOM_METADATA values
(
    'FIGURY', 
    'KSZTALT', 
    MDSYS.SDO_DIM_ARRAY(
        MDSYS.SDO_DIM_ELEMENT('X', 0, 10, 0.01),
        MDSYS.SDO_DIM_ELEMENT('Y', 0, 10, 0.01)
    ),
    null
);


--B
select SDO_TUNE.ESTIMATE_RTREE_INDEX_SIZE(3000000, 8192, 10, 2, 0)
from dual;

--C
create index figury_idx on figury(ksztalt) indextype is MDSYS.SPATIAL_INDEX_V2;

--D
select id
from figury
where SDO_FILTER(ksztalt,
SDO_GEOMETRY(2001,null,
 SDO_POINT_TYPE(3,3,null),
 null,null)) = 'TRUE';
--nie
--SDO_FILTER wykorzystuje jedynie pierwszą fazę zapytania, więc nie zwróci doładnego wyniku a jedynie kandydatów do wyniku

--E
select id
from figury
where SDO_RELATE(ksztalt,
 SDO_GEOMETRY(2001,null,
 SDO_POINT_TYPE(3,3,null),
 null,null),
 'mask=ANYINTERACT') = 'TRUE';
 --tak

--2
--A
with warsaw as (
    select geom
    from major_cities
    where city_name = 'Warsaw'
)
select mc.city_name,
    SDO_NN_DISTANCE(1) as odl
from major_cities mc, 
    warsaw w
where sdo_nn(mc.geom, w.geom, 'sdo_num_res=9', 1) = 'TRUE'
    and mc.city_name != 'Warsaw'
order by odl;

--B
with warsaw as (
select geom
from major_cities
where city_name = 'Warsaw'
)
select mc.city_name
from major_cities mc, 
warsaw w
where sdo_within_distance(mc.geom, w.geom, 'distance = 100 unit = km') = 'TRUE'
and mc.city_name != 'Warsaw';

--C
with slovakia as(
select cntry_name, geom
from country_boundaries
where cntry_name = 'Slovakia'
)
select s.cntry_name as kraj,
mc.city_name as miasto
from major_cities mc,
slovakia s
where SDO_RELATE(mc.geom, s.geom, 'mask=inside') = 'TRUE';

--D
with poland as(
select cntry_name, geom
from country_boundaries
where cntry_name = 'Poland'
)
select cb.cntry_name as panstwo,
SDO_GEOM.SDO_DISTANCE(cb.geom, p.geom, 1, 'unit=km') as odl
from country_boundaries cb,
poland p
where SDO_RELATE(p.geom, cb.geom, 'mask=touch') != 'TRUE'
and cb.cntry_name != 'Poland';

--3
--A
with poland as(
select cntry_name, geom
from country_boundaries
where cntry_name = 'Poland'
)
select cb.cntry_name as panstwo,
SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(cb.geom, p.geom, 1), 1, 'unit=km') as odl
from country_boundaries cb,
poland p
WHERE SDO_RELATE(cb.geom, p.geom, 'mask=touch') = 'TRUE' ;

--B
select cntry_name 
from country_boundaries
where sdo_geom.sdo_area(geom) = (select max(sdo_geom.sdo_area(geom))
                                    from country_boundaries);

--C
with warszawa as(
select geom 
from major_cities
where city_name = 'Warsaw'
),
lodz as(
select geom 
from major_cities
where city_name = 'Lodz'
)
select SDO_GEOM.SDO_AREA(SDO_GEOM.SDO_MBR(SDO_GEOM.SDO_UNION(w.geom, l.geom, 0.01)), 0.01, 'unit=SQ_KM') as SQ_KM
from warszawa w, lodz l;

--D
with poland as(
select geom 
from country_boundaries
where cntry_name = 'Poland'
),
prague as(
select geom 
from major_cities
where city_name = 'Prague'
)
select SDO_GEOM.SDO_UNION(pl.geom, pr.geom, 0.01).GET_DIMS() ||
       SDO_GEOM.SDO_UNION(pl.geom, pr.geom, 0.01).GET_LRS_DIM() ||
       LPAD(SDO_GEOM.SDO_UNION(pl.geom, pr.geom, 0.01).GET_GTYPE(), 2, '0') as gtype
from poland pl, prague pr;

--E
select mc.city_name, cb.cntry_name
from country_boundaries cb, major_cities mc
where cb.cntry_name = mc.cntry_name
and SDO_GEOM.SDO_DISTANCE(SDO_GEOM.SDO_CENTROID(cb.geom, 1), mc.geom, 1) = (
    select min(SDO_GEOM.SDO_DISTANCE(SDO_GEOM.SDO_CENTROID(cb.geom, 1), mc.geom, 1))
from country_boundaries cb, major_cities mc
where cb.cntry_name = mc.cntry_name);

--F
select r.name, 
sum(SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(r.geom, cb.geom, 1), 1, 'unit=km')) as dlugosc
from rivers r, country_boundaries cb 
where cb.cntry_name = 'Poland' and SDO_RELATE(r.geom, cb.geom, 'mask=ANYINTERACT') = 'TRUE'
group by r.name;

