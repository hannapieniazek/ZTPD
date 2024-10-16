--1 
create table movies as
select * from ztpd.movies;

--2
desc movies;

--3
select id, title 
from movies 
where cover is null;

--4
select id, title, dbms_lob.getlength(cover) as filesize
from movies 
where cover is not null;

--5
select id, title, dbms_lob.getlength(cover) as filesize
from movies 
where cover is null;

--6
select directory_name, directory_path
from all_directories;

--7
update movies 
set cover = empty_blob(),
mime_type = 'image/jpeg'
where id = 66;

--8
select id, title, dbms_lob.getlength(cover) as filesize
from movies 
where id in (65,66);

--9
declare
    lobd blob;
    cover BFILE := BFILENAME('ZSBD_DIR','escape.jpg');
begin
    select cover into lobd
    from movies
    where id = 66
    for update;
    DBMS_LOB.fileopen(cover, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADFROMFILE(lobd,cover,DBMS_LOB.GETLENGTH(cover));
    DBMS_LOB.FILECLOSE(cover);
    commit;
end;

--10
create table temp_covers
(
    movie_id number(12),
    image bfile,
    mime_type varchar2(50)
);

--11
insert into temp_covers 
values(
    65, 
    bfilename('ZSBD_DIR', 'eagles.jpg'), 
    'image/jpeg'
);


--12
select movie_id, 
       dbms_lob.getlength(image) as filesize
from temp_covers;

--13
declare
    lobd BLOB;
    cover BFILE;
    mimetype varchar2(50);
begin 
    select image, mime_type
    into cover, mimetype
    from temp_covers 
    where movie_id = 65;

    DBMS_LOB.CREATETEMPORARY(lobd, true);

    DBMS_LOB.FILEOPEN(cover, dbms_lob.file_readonly);
    DBMS_LOB.LOADFROMFILE(lobd, cover, dbms_lob.getlength(cover));
    DBMS_LOB.FILECLOSE(cover);

    update movies
    set cover = lobd,
    mime_type = mimetype
    where id = 65;

    DBMS_LOB.FREETEMPORARY(lobd);

    COMMIT;
end;

--14
select id as movie_id, 
       dbms_lob.getlength(cover) as filesize
from movies 
where id in (65,66); 

--15
drop table movies;