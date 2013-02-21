set client_encoding to 'UTF8';
-- Januar
create table banks_raw (id integer, name varchar(255));
create table companies_raw (id integer, jib varchar(255), name varchar(255));
create table accounts_raw (id integer, company_id integer, bank_id integer, account varchar(255), name varchar(255));

\copy banks_raw from 'c:\dev\private\team05\dev\bobak\db\export\2013-01-03\banks.csv' csv header;
\copy companies_raw from 'c:\dev\private\team05\dev\bobak\db\export\2013-01-03\companies.csv' csv header;
\copy accounts_raw from 'c:\dev\private\team05\dev\bobak\db\export\2013-01-03\accounts.csv' csv header;


-- BANKS
ALTER TABLE ONLY banks ALTER COLUMN created_at SET DEFAULT current_timestamp;
ALTER TABLE ONLY banks ALTER COLUMN updated_at SET DEFAULT current_timestamp;

-- Insert new banks
insert into banks (name)
(select name from banks_raw) except (select name from banks)

ALTER TABLE ONLY banks ALTER COLUMN created_at SET DEFAULT null;
ALTER TABLE ONLY banks ALTER COLUMN updated_at SET DEFAULT null;

-- Companies
ALTER TABLE ONLY firms ALTER COLUMN created_at SET DEFAULT current_timestamp;
ALTER TABLE ONLY firms ALTER COLUMN updated_at SET DEFAULT current_timestamp;

insert into firms(jib, name)
(select jib,name from companies_raw) except (select jib,name from firms)

ALTER TABLE ONLY firms ALTER COLUMN created_at SET DEFAULT null;
ALTER TABLE ONLY firms ALTER COLUMN updated_at SET DEFAULT null;

-- Accounts
TRUNCATE accounts;

ALTER TABLE ONLY accounts ALTER COLUMN created_at SET DEFAULT current_timestamp;
ALTER TABLE ONLY accounts ALTER COLUMN updated_at SET DEFAULT current_timestamp;

insert into accounts(number, bank_id, firm_id, name)
(select a.account, b2.id, c2.id, a.name 
from accounts_raw_2 a inner join banks_raw_2 b on a.bank_id=b.id 
inner join companies_raw_2 c on a.company_id=c.id 
inner join banks b2 on b.name=b2.name 
inner join firms c2 on c.jib=c2.jib) 
except 
(select number, bank_id, firm_id, name from accounts)

ALTER TABLE ONLY accounts ALTER COLUMN created_at SET DEFAULT null;
ALTER TABLE ONLY accounts ALTER COLUMN updated_at SET DEFAULT null;

select a.number, a.name, b.name from accounts a inner join banks b on a.bank_id = b.id where firm_id=53025 order by bank_id
-- Account status 
select count(f.id), f.id, f.name from accounts a inner join firms f on a.firm_id = f.id group by f.name, f.id order by count(a.firm_id) desc limit 20




create table banks_raw_2 (id integer, name varchar(255));
create table companies_raw_2 (id integer, jib varchar(255), name varchar(255));
create table accounts_raw_2 (id integer, company_id integer, bank_id integer, account varchar(255), name varchar(255));

truncate banks_raw;
truncate companies_raw;
truncate accounts_raw;

\copy banks_raw_2 from 'c:\dev\private\team05\dev\bobak\db\export\2013-02-01\banks.csv' csv header;
\copy companies_raw_2 from 'c:\dev\private\team05\dev\bobak\db\export\2013-02-01\companies.csv' csv header;
\copy accounts_raw_2 from 'c:\dev\private\team05\dev\bobak\db\export\2013-02-01\accounts.csv' csv header;


-- BANKS
TRUNCATE banks;

ALTER TABLE ONLY banks ALTER COLUMN created_at SET DEFAULT current_timestamp;
ALTER TABLE ONLY banks ALTER COLUMN updated_at SET DEFAULT current_timestamp;

-- Insert new banks
insert into banks (name)
(select name from banks_raw_2) except (select name from banks)

ALTER TABLE ONLY banks ALTER COLUMN created_at SET DEFAULT null;
ALTER TABLE ONLY banks ALTER COLUMN updated_at SET DEFAULT null;

-- Companies
TRUNCATE firms;

ALTER TABLE ONLY firms ALTER COLUMN created_at SET DEFAULT current_timestamp;
ALTER TABLE ONLY firms ALTER COLUMN updated_at SET DEFAULT current_timestamp;

insert into firms(jib, name)
(select jib,name from companies_raw_2) except (select jib,name from firms)

ALTER TABLE ONLY firms ALTER COLUMN created_at SET DEFAULT null;
ALTER TABLE ONLY firms ALTER COLUMN updated_at SET DEFAULT null;

-- Accounts
TRUNCATE accounts;

ALTER TABLE ONLY accounts ALTER COLUMN created_at SET DEFAULT current_timestamp;
ALTER TABLE ONLY accounts ALTER COLUMN updated_at SET DEFAULT current_timestamp;

insert into accounts(number, bank_id, firm_id, name)
(select a.account, b2.id, c2.id, a.name 
from accounts_raw_2 a inner join banks_raw_2 b on a.bank_id=b.id 
inner join companies_raw_2 c on a.company_id=c.id 
inner join banks b2 on b.name=b2.name 
inner join firms c2 on c.jib=c2.jib) 
except 
(select number, bank_id, firm_id, name from accounts)

ALTER TABLE ONLY accounts ALTER COLUMN created_at SET DEFAULT null;
ALTER TABLE ONLY accounts ALTER COLUMN updated_at SET DEFAULT null;

select a.number, a.name, b.name from accounts a inner join banks b on a.bank_id = b.id where firm_id=53025 order by bank_id
-- Account status 
select count(f.id), f.id, f.name from accounts a inner join firms f on a.firm_id = f.id group by f.name, f.id order by count(a.firm_id) desc limit 20