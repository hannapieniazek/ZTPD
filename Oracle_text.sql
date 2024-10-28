--Operator CONTAINS - Podstawy
--1
create table cytaty as
select * from ztpd.cytaty;

--2
select autor, tekst 
from cytaty
where lower(tekst) like '%pesymista%' 
or lower(tekst) like '%optymista%';

--3
create index cytaty_text_idx on cytaty(tekst)
indextype is ctxsys.context;

--4
select autor, tekst
from cytaty
where contains(tekst, 'optymista')>0
and contains(tekst, 'pesymista')>0;

--5
select autor, tekst
from cytaty
where contains(tekst, 'optymista')=0
and contains(tekst, 'pesymista')>0;

--6
select autor, tekst 
from cytaty
where contains(tekst, 'near((pesymista, optymista), 3)')>0;

--7
select autor, tekst 
from cytaty
where contains(tekst, 'near((pesymista, optymista), 10)')>0;

--8
select autor, tekst 
from cytaty
where contains(tekst, 'życi%')>0;

--9
select autor, tekst, score(1)
from cytaty
where contains(tekst, 'życi%', 1)>0;

--10
select autor, tekst, score(1)
from cytaty
where contains(tekst, 'życi%', 1)>0
and rownum = 1
order by score(1) desc;

-- 11
select autor, tekst 
from cytaty
where contains(tekst, 'fuzzy(probelm)', 1)>0;

-- 12
insert into cytaty
values (
    (select count(*)+1 from cytaty), 
    'Bertrand Russell', 
    'To smutne, że głupcy są tacy pewni siebie, a ludzie rozsądni tacy pełni wątpliwości.');

-- 13
select autor, tekst 
from cytaty
where contains(tekst, 'głupcy')>0;
-- Nie ma go w indeksie, ponieważ indeks nie jest automatycznie aktualizowany.

-- 14
select *
from dr$cytaty_text_idx$i
where token_text = 'GŁUPCY';

-- 15
drop index cytaty_text_idx;

create index cytaty_text_idx on cytaty(tekst)
indextype is ctxsys.context;

-- 16
select *
from dr$cytaty_text_idx$i
where token_text = 'GŁUPCY';

select autor, tekst 
from cytaty
where contains(tekst, 'głupcy')>0;

-- 17
drop index cytaty_text_idx;

drop table cytaty;

-- Zaawansowane indeksowanie i wyszukiwanie
-- 1
create table quotes as
select * from ztpd.quotes;

-- 2
create index quotes_text_idx
on quotes(text)
indextype is ctxsys.context;

-- 3
select author, text
from quotes
where contains(text, 'work')>0;

select author, text
from quotes
where contains(text, '$work')>0;

select author, text
from quotes
where contains(text, 'working')>0;

select author, text
from quotes
where contains(text, '$working')>0;

-- 4
select author, text
from quotes
where contains(text, 'it')>0;
--Nie, gdyż słowo 'it' należy do stopwords

-- 5
select *
from CTX_STOPLISTS;

-- 6
select *
from CTX_STOPWORDS;

-- 7
drop index quotes_text_idx;

create index quotes_text_idx on quotes(text)
indextype is CTXSYS.CONTEXT
parameters ('stoplist CTXSYS.EMPTY_STOPLIST');

-- 8
select author, text
from quotes
where contains(text, 'it')>0;

-- 9
select author, text
from quotes
where contains(text, 'fool and humans')>0;

-- 10
select author, text
from quotes
where contains(text, 'fool and computer')>0;

-- 11
select author, text
from quotes
where contains(text, '(fool and humans) within sentence')>0;
-- brak sekcji sentence

-- 12
drop index quotes_text_idx;

-- 13
begin
    ctx_ddl.create_section_group('nullgroup', 'NULL_SECTION_GROUP');
    ctx_ddl.add_special_section('nullgroup', 'SENTENCE');
    ctx_ddl.add_special_section('nullgroup', 'PARAGRAPH');
end;

-- 14
create index quotes_text_idx
on quotes(text)
indextype is CTXSYS.CONTEXT
parameters ('stoplist CTXSYS.EMPTY_STOPLIST section group nullgroup');

-- 15
select author, text
from quotes
where contains(text, '(fool and humans) within sentence')>0;

select author, text
from quotes
where contains(text, '(fool and computer) within sentence')>0;

-- 16
select author, text
from quotes
where contains(text, 'humans')>0;
--Tak, '-' dzieli wyraz na dwa osobne tokeny

-- 17
drop index quotes_text_idx;

begin
    ctx_ddl.create_preference('dash_lexer', 'BASIC_LEXER');
    ctx_ddl.set_attribute('dash_lexer', 'printjoins', '-');
    ctx_ddl.set_attribute ('dash_lexer', 'index_text', 'YES');
end;

create index quotes_text_idx
on quotes(text)
indextype is CTXSYS.CONTEXT
parameters ('stoplist CTXSYS.EMPTY_STOPLIST section group nullgroup lexer dash_lexer');

-- 18
select author, text
from quotes
where contains(text, 'humans')>0;

-- 19
select author, text
from quotes
where contains(text, 'non\-humans')>0;

-- 20
drop table quotes;

begin
    CTX_DDL.DROP_SECTION_GROUP('nullgroup');
    CTX_DDL.DROP_PREFERENCE('dash_lexer');
end;