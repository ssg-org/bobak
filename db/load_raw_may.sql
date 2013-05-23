-- psql -f db/load_raw_may.sql -h localhost -d bobak-dev -U bobak

create table maj (id varchar(255), account varchar(255), name text, bank varchar(255));

\copy maj  from db/export/2013-05-03.csv csv header