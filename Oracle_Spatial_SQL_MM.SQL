--1
--A
select lpad('-',2*(level-1),'|-') || t.owner||'.'||t.type_name||' (FINAL:'||t.final||
', INSTANTIABLE:'||t.instantiable||', ATTRIBUTES:'||t.attributes||', METHODS:'||t.methods||')'
from all_types t
start with t.type_name = 'ST_GEOMETRY'
connect by prior t.type_name = t.supertype_name
 and prior t.owner = t.owner;


--B
select distinct m.method_name
from all_type_methods m
where m.type_name like 'ST_POLYGON'
and m.owner = 'MDSYS'
order by 1;


--C
create table myst_major_cities (
    fips_cntry varchar2(2),
    city_name varchar2(40),
    stgeom st_point
);

--D
insert into myst_major_cities
select fips_cntry, city_name, st_point(geom) as stgeom
from major_cities;

--2
--A
insert into myst_major_cities values(
'PL', 
'Szczyrk',
ST_POINT(19.036107,  49.718655, 4326));

--3
--A
create table myst_country_boundaries (
    fips_cntry varchar2(2),
    cntry_name varchar2(40),
    stgeom st_multipolygon
);

--B
insert into myst_country_boundaries
select 
    fips_cntry,
    cntry_name,
    st_multipolygon(geom) as stgeom
from country_boundaries;

--C
select mcb.STGEOM.ST_GEOMETRYTYPE() as typ_obiektu, 
count(*) as ile
from myst_country_boundaries mcb
group by mcb.STGEOM.ST_GEOMETRYTYPE();

-- D
select mcb.STGEOM.ST_ISSIMPLE()
from myst_country_boundaries mcb;

--4
--A
select mcb.cntry_name, count(*)
from myst_country_boundaries mcb, myst_major_cities mmc
where mcb.stgeom.st_contains(mmc.stgeom) = 1 
and city_name != 'Szczyrk'
group by mcb.cntry_name;

--B
with czech_republic as (
    select cntry_name, stgeom 
    from myst_country_boundaries
    where cntry_name = 'Czech Republic'
)
select a.cntry_name as a_name, 
b.cntry_name as b_name
from myst_country_boundaries a,
czech_republic b
where a.stgeom.st_touches(b.stgeom) = 1;

--C
with czech_republic as (
    select cntry_name, stgeom 
    from myst_country_boundaries
    where cntry_name = 'Czech Republic'
)
select distinct c.cntry_name,
r.name
from rivers r,
czech_republic c
where c.stgeom.st_crosses(st_linestring(r.geom)) = 1;

--D
with czech_republic as (
    select cntry_name, stgeom 
    from myst_country_boundaries
    where cntry_name = 'Czech Republic'
),
slovakia as (
    select cntry_name, stgeom 
    from myst_country_boundaries
    where cntry_name = 'Slovakia'
)
select treat(c.stgeom.st_union(s.stgeom) as st_polygon).st_area()
from czech_republic c,
slovakia s;

--E
with hungary as (
    select cntry_name, stgeom 
    from myst_country_boundaries
    where cntry_name = 'Hungary'
),
balaton as (
    select geom 
    from water_bodies
    where name = 'Balaton'
)
select h.stgeom.st_difference(st_geometry(b.geom)) as obiekt,
h.stgeom.st_difference(st_geometry(b.geom)).st_geometrytype() as wegry_bez
from hungary h,
balaton b;

-- Zad 5
-- A
with poland as (
    select cntry_name, stgeom 
    from myst_country_boundaries
    where cntry_name = 'Poland'
)
select p.cntry_name as a_name, count(*)
from myst_major_cities mmc,
poland p
where sdo_within_distance(mmc.stgeom, p.stgeom, 'distance=100 unit=km') = 'TRUE'
group by p.cntry_name;

explain plan for
with poland as (
    select cntry_name, stgeom 
    from myst_country_boundaries
    where cntry_name = 'Poland'
)
select p.cntry_name as a_name, count(*)
from myst_major_cities mmc,
poland p
where sdo_within_distance(mmc.stgeom, p.stgeom, 'distance=100 unit=km') = 'TRUE'
group by p.cntry_name;

select *
from table (dbms_xplan.display);


-- B
insert into user_sdo_geom_metadata
select 'myst_major_cities', 
'stgeom',
diminfo, 
srid
from all_sdo_geom_metadata 
where table_name = 'MAJOR_CITIES';

insert into user_sdo_geom_metadata
select 'myst_country_boundaries', 
'stgeom',
diminfo, 
srid
from all_sdo_geom_metadata 
where table_name = 'COUNTRY_BOUNDARIES';

 
-- C
create index myst_major_cities_idx on
myst_major_cities(stgeom)
indextype is mdsys.spatial_index;

create index myst_country_boundaries_idx on
myst_country_boundaries(stgeom)
indextype is mdsys.spatial_index;

-- D
with poland as (
    select cntry_name, stgeom 
    from myst_country_boundaries
    where cntry_name = 'Poland'
)
select p.cntry_name as a_name, count(*)
from myst_major_cities mmc,
poland p
where sdo_within_distance(mmc.stgeom, p.stgeom, 'distance=100 unit=km') = 'TRUE'
group by p.cntry_name;

explain plan for
with poland as (
    select cntry_name, stgeom 
    from myst_country_boundaries
    where cntry_name = 'Poland'
)
select p.cntry_name as a_name, count(*)
from myst_major_cities mmc,
poland p
where sdo_within_distance(mmc.stgeom, p.stgeom, 'distance=100 unit=km') = 'TRUE'
group by p.cntry_name;

select *
from table (dbms_xplan.display);