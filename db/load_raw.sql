-- psql -f db/load_raw.sql -h localhost -d bobak-dev -U bobak

set client_encoding to 'UTF8';

TRUNCATE TABLE banks;
TRUNCATE TABLE owners;
TRUNCATE TABLE accounts;
TRUNCATE TABLE account_statuses;
TRUNCATE TABLE bank_summaries;
TRUNCATE TABLE owner_summaries;

-- Load raw data
drop table januar;
drop table februar;
drop table mart;

create table januar (id varchar(255), account varchar(255), name text, bank varchar(255));
create table februar (id varchar(255), account varchar(255), name text, bank varchar(255));
create table mart (id varchar(255), account varchar(255), name text, bank varchar(255));

\copy januar  from db/export/2013-01-03.csv csv header
\copy februar from db/export/2013-02-01.csv csv header
\copy mart    from db/export/2013-03-01.csv csv header