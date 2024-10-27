--1
--A
create table figury
(
    id number(10) primary key,
    ksztalt MDSYS.SDO_GEOMETRY
);

--B1 KOLO
insert into figury values
(
    1, SDO_GEOMETRY(
        2003, 
        null, 
        null, 
        SDO_ELEM_INFO_ARRAY(1,1003,4), 
        SDO_ORDINATE_ARRAY(3,5, 5,3, 7,5)
    )
);

--B2 KWADRAT
insert into figury values
(
    2, SDO_GEOMETRY(
        2003, 
        null, 
        null, 
        SDO_ELEM_INFO_ARRAY(1,1003,3), 
        SDO_ORDINATE_ARRAY(1,1, 5,5)
    )
);

--B3
insert into figury values
(
    3, SDO_GEOMETRY(
        2002, 
        null, 
        null, 
        SDO_ELEM_INFO_ARRAY(1,4,2, 1,2,1, 5,2,2),
        SDO_ORDINATE_ARRAY(3,2, 6,2, 7,3, 8,2, 7,1)
    )
);

--C
insert into figury values
(
    4, SDO_GEOMETRY(
        2002, 
        null, 
        null, 
        SDO_ELEM_INFO_ARRAY(1, 1003, 4),
        SDO_ORDINATE_ARRAY(1, 1, 2, 2, 3, 3)
    )
);

--D
select id, SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt,0.01)
from figury;

--E
delete
from figury where SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt,0.01) != 'TRUE';

--F
commit;