set table=%1
set file=%2

psql -d bobak-dev -U bobak -h localhost <<EOF
\set client_encoding to 'UTF8';

drop table %table%;
\copy %table% FROM %file% csv header
EOF	