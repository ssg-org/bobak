-- Script variagles:
-- :raw_table - table name to load raw data from file
-- :date - date of load

-- Command: psql -v raw_table=januar -v date='2013-01-03' -f db\import.sql -d bobak-dev -U bobak

set client_encoding to 'UTF8';

-- Load raw data
drop table :raw_table;
create table :raw_table (id varchar(255), account varchar(255), name text, bank varchar(255));

\copy februar from db/export/2013-02-01.csv csv header

-- BANKS
ALTER TABLE ONLY banks ALTER COLUMN created_at SET DEFAULT current_timestamp;
ALTER TABLE ONLY banks ALTER COLUMN updated_at SET DEFAULT current_timestamp;

insert into banks (name)
(select distinct bank from :raw_table) except (select name from banks);

ALTER TABLE ONLY banks ALTER COLUMN created_at SET DEFAULT null;
ALTER TABLE ONLY banks ALTER COLUMN updated_at SET DEFAULT null;

-- Owners
ALTER TABLE ONLY owners ALTER COLUMN created_at SET DEFAULT current_timestamp;
ALTER TABLE ONLY owners ALTER COLUMN updated_at SET DEFAULT current_timestamp;

insert into owners(oid, name)
(select id, name from :raw_table group by id, name) except (select oid, name from owners);

ALTER TABLE ONLY owners ALTER COLUMN created_at SET DEFAULT null;
ALTER TABLE ONLY owners ALTER COLUMN updated_at SET DEFAULT null;

-- Accounts
ALTER TABLE ONLY accounts ALTER COLUMN created_at SET DEFAULT current_timestamp;
ALTER TABLE ONLY accounts ALTER COLUMN updated_at SET DEFAULT current_timestamp;

insert into accounts(number, name, bank_id, owner_id)
(select :raw_table.account, :raw_table.name, banks.id, owners.id 
	from :raw_table 
	inner join banks on :raw_table.bank = banks.name
	inner join owners on :raw_table.id = owners.oid and :raw_table.name = owners.name) except (select number, name, bank_id, owner_id from accounts);

ALTER TABLE ONLY accounts ALTER COLUMN created_at SET DEFAULT null;
ALTER TABLE ONLY accounts ALTER COLUMN updated_at SET DEFAULT null;

-- Account statuses
ALTER TABLE ONLY account_statuses ALTER COLUMN created_at SET DEFAULT current_timestamp;
ALTER TABLE ONLY account_statuses ALTER COLUMN updated_at SET DEFAULT current_timestamp;

insert into account_statuses(account_id, date, status)
(select id, :date, 0 from accounts where owner_id is null);

ALTER TABLE ONLY account_statuses ALTER COLUMN created_at SET DEFAULT null;
ALTER TABLE ONLY account_statuses ALTER COLUMN updated_at SET DEFAULT null;