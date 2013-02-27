-- Script variagles:
-- :raw_table - table name to load raw data from file
-- :date - date of load

-- Command: psql -v raw_table=januar -v date=\'2013-01-03\' -f db/import.sql -h localhost -d bobak-dev -U bobak

set client_encoding to 'UTF8';

TRUNCATE TABLE banks;
TRUNCATE TABLE owners;
TRUNCATE TABLE accounts;
TRUNCATE TABLE account_statuses;

-- Load raw data
drop table :raw_table;
create table :raw_table (id varchar(255), account varchar(255), name text, bank varchar(255));

\copy januar from db/export/2013-01-03.csv csv header

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
(select id, name
	from (
			(select id, name, ROW_NUMBER() OVER (PARTITION BY id ORDER BY LENGTH(name) DESC) as row_num
			from januar
			where id is not null
			order by row_num desc)
			union
			(select distinct id, name, 1
			from januar
			where id is null)) a
	where a.row_num=1 ) 
except (select oid, name from owners);

ALTER TABLE ONLY owners ALTER COLUMN created_at SET DEFAULT null;
ALTER TABLE ONLY owners ALTER COLUMN updated_at SET DEFAULT null;

-- Accounts
ALTER TABLE ONLY accounts ALTER COLUMN created_at SET DEFAULT current_timestamp;
ALTER TABLE ONLY accounts ALTER COLUMN updated_at SET DEFAULT current_timestamp;

insert into accounts(number, name, bank_id, owner_id)
(
	(select :raw_table.account, :raw_table.name, banks.id, owners.id 
	from :raw_table 
	inner join banks on :raw_table.bank = banks.name
	inner join owners on :raw_table.id = owners.oid)
	union
	(select :raw_table.account, :raw_table.name, banks.id, owners.id 
	from :raw_table 
	inner join banks on :raw_table.bank = banks.name
	inner join owners on :raw_table.name = owners.name
	where :raw_table.id is null)
)
except 
(select number, name, bank_id, owner_id from accounts);

ALTER TABLE ONLY accounts ALTER COLUMN created_at SET DEFAULT null;
ALTER TABLE ONLY accounts ALTER COLUMN updated_at SET DEFAULT null;

-- Account statuses
ALTER TABLE ONLY account_statuses ALTER COLUMN created_at SET DEFAULT current_timestamp;
ALTER TABLE ONLY account_statuses ALTER COLUMN updated_at SET DEFAULT current_timestamp;

insert into account_statuses(account_id, date, status)
(select accounts.id, :date, 0
	from :raw_table inner join accounts on :raw_table.account = accounts.number);

ALTER TABLE ONLY account_statuses ALTER COLUMN created_at SET DEFAULT null;
ALTER TABLE ONLY account_statuses ALTER COLUMN updated_at SET DEFAULT null;