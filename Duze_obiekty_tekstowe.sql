--1
create table dokumenty
(
    id number(12) primary key,
    dokument clob
);

--2
declare
tmp clob := empty_clob();
begin 
    for i in 1..10000 loop
        tmp:=concat(tmp, 'Oto tekst. ');
    end loop;
insert into dokumenty(id, dokument) values (1, tmp);
end;

--3
select * from dokumenty;
select upper(dokument) from dokumenty;
select length(dokument) from dokumenty;
select DBMS_LOB.GETLENGTH(dokument) from dokumenty;
select substr(dokument, 5, 1000) from dokumenty;
select DBMS_LOB.SUBSTR(dokument, 1000, 5) from dokumenty;

--4
insert into dokumenty(id, dokument) values(2, empty_clob());

--5
insert into dokumenty(id, dokument) values(3, null);

--6
select * from dokumenty;
select upper(dokument) from dokumenty;
select length(dokument) from dokumenty;
select DBMS_LOB.GETLENGTH(dokument) from dokumenty;
select substr(dokument, 5, 1000) from dokumenty;
select DBMS_LOB.SUBSTR(dokument, 1000, 5) from dokumenty;

--7
declare
    lobd clob;
    fils bfile := bfilename('TPD_DIR', 'dokument.txt');
    doffset integer := 1;
    soffset integer := 1;
    langctx integer := 0;
    warn integer := null;
begin
    select dokument into lobd from dokumenty 
    where id = 2 for update;
    DBMS_LOB.FILEOPEN(fils, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADCLOBFROMFILE(lobd, fils, DBMS_LOB.GETLENGTH(fils), doffset, soffset, 0, langctx, warn);
    DBMS_LOB.FILECLOSE(fils);
    commit;
    DBMS_OUTPUT.PUT_LINE('Status operacji: ' || warn);
end;

--8
update dokumenty
set dokument = TO_CLOB(bfilename('TPD_DIR', 'dokument.txt'))
where id = 3;

--9
select * from dokumenty;

--10
select id, DBMS_LOB.GETLENGTH(dokument)
from dokumenty;

--11
drop table dokumenty;

--12
create or replace procedure CLOB_CENSOR(
    in_clob in out clob, 
    text_replace in varchar2) 
    as 
    pos integer := 1;

begin
    loop
        pos := instr(in_clob, text_replace, pos);
        exit when pos = 0;
        DBMS_LOB.WRITE(in_clob, length(text_replace), pos, RPAD('.', length(text_replace), '.'));
        pos := pos + length(text_replace);
    end loop;
end;


--13
create table biographies as 
select * from ztpd.biographies;

declare
v_bio clob;
begin
    select bio 
    into v_bio 
    from biographies 
    where person = 'Jara Cimrman' 
    for update;

    CLOB_CENSOR(v_bio, 'Cimrman');

    update biographies
    set bio = v_bio
    where person = 'Jara Cimrman';

    commit;
end;

--14
drop table biographies;