-- Script variagles:
-- :raw_table - table name to load raw data from file
-- :date - date of load

-- Command: psql -v raw_table=mart -v date=\'2013-03-01\' -f db/import.sql -h localhost -d bobak-dev -U bobak

set client_encoding to 'UTF8';

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

-- Import only owners with OID that are new
insert into owners(oid, name)
(	select id, name 
	from
		(select 
			:raw_table.id,
			:raw_table.name, 
			ROW_NUMBER() OVER (PARTITION BY :raw_table.id ORDER BY LENGTH(:raw_table.name) DESC, :raw_table.account) as row_num
		from :raw_table left join owners on :raw_table.id = owners.oid
		where owners.id is null and :raw_table.id is not null) a
	where a.row_num = 1
);

ALTER TABLE ONLY owners ALTER COLUMN created_at SET DEFAULT null;
ALTER TABLE ONLY owners ALTER COLUMN updated_at SET DEFAULT null;

-- Accounts
ALTER TABLE ONLY accounts ALTER COLUMN created_at SET DEFAULT current_timestamp;
ALTER TABLE ONLY accounts ALTER COLUMN updated_at SET DEFAULT current_timestamp;

insert into accounts(number, name, bank_id, owner_id)
(
	select :raw_table.account, :raw_table.name, banks.id, owners.id 
	from :raw_table 
		inner join banks on :raw_table.bank = banks.name
		inner join owners on :raw_table.id = owners.oid
		left join accounts on :raw_table.account = accounts.number
	where accounts.id is null
);

ALTER TABLE ONLY accounts ALTER COLUMN created_at SET DEFAULT null;
ALTER TABLE ONLY accounts ALTER COLUMN updated_at SET DEFAULT null;

-- Account statuses
ALTER TABLE ONLY account_statuses ALTER COLUMN created_at SET DEFAULT current_timestamp;
ALTER TABLE ONLY account_statuses ALTER COLUMN updated_at SET DEFAULT current_timestamp;

insert into account_statuses(account_id, date, year, month, day, status)
(select accounts.id, :date, date_part('year',DATE :date), date_part('month',DATE :date), date_part('day',DATE :date), 0
	from :raw_table inner join accounts on :raw_table.account = accounts.number);

ALTER TABLE ONLY account_statuses ALTER COLUMN created_at SET DEFAULT null;
ALTER TABLE ONLY account_statuses ALTER COLUMN updated_at SET DEFAULT null;

-- Bank summaries
ALTER TABLE ONLY bank_summaries ALTER COLUMN created_at SET DEFAULT current_timestamp;
ALTER TABLE ONLY bank_summaries ALTER COLUMN updated_at SET DEFAULT current_timestamp;

INSERT INTO bank_summaries(bank_id, date, year, month, day, blocked_accounts, blocked_owners)
(SELECT
	banks.id, account_statuses.date, account_statuses.year, account_statuses.month, account_statuses.day, count(distinct accounts.id), count(distinct accounts.owner_id)
 FROM banks 
 	INNER JOIN accounts on banks.id = accounts.bank_id
 	INNER JOIN account_statuses on accounts.id = account_statuses.account_id
 WHERE
 	account_statuses.date = DATE :date
 GROUP BY banks.id, account_statuses.date, account_statuses.year, account_statuses.month, account_statuses.day);

ALTER TABLE ONLY bank_summaries ALTER COLUMN created_at SET DEFAULT null;
ALTER TABLE ONLY bank_summaries ALTER COLUMN updated_at SET DEFAULT null;

-- Account summaries
ALTER TABLE ONLY owner_summaries ALTER COLUMN created_at SET DEFAULT current_timestamp;
ALTER TABLE ONLY owner_summaries ALTER COLUMN updated_at SET DEFAULT current_timestamp;

INSERT INTO owner_summaries(owner_id, date, year, month, day, blocked_accounts)
(SELECT
	owners.id, account_statuses.date, account_statuses.year, account_statuses.month, account_statuses.day, count(owners.id)
 FROM owners
 	INNER JOIN accounts on accounts.owner_id = owners.id
 	INNER JOIN account_statuses on accounts.id = account_statuses.account_id
 WHERE
 	account_statuses.date = DATE :date
 GROUP BY owners.id, account_statuses.date, account_statuses.year, account_statuses.month, account_statuses.day);

ALTER TABLE ONLY owner_summaries ALTER COLUMN created_at SET DEFAULT null;
ALTER TABLE ONLY owner_summaries ALTER COLUMN updated_at SET DEFAULT null;
