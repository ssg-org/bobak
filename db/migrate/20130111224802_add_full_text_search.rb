class AddFullTextSearch < ActiveRecord::Migration
  def up
		 execute(<<-'eosql'.strip)
		      ALTER TABLE firms ADD COLUMN full_text tsvector;

		      CREATE FUNCTION firms_generate_tsvector() RETURNS trigger AS $$
		        begin
		          new.full_text :=
		            setweight(to_tsvector('pg_catalog.english', coalesce(new.jib,'')), 'A') ||
		            setweight(to_tsvector('pg_catalog.english', coalesce(new.name,'')), 'B');
		          return new;
		        end
		      $$ LANGUAGE plpgsql;

		      CREATE TRIGGER tsvector_firms_upsert_trigger BEFORE INSERT OR UPDATE
		        ON firms
		        FOR EACH ROW EXECUTE PROCEDURE firms_generate_tsvector();

		      UPDATE firms SET full_text =
		        setweight(to_tsvector('pg_catalog.english', coalesce(jib,'')), 'A') ||
		        setweight(to_tsvector('pg_catalog.english', coalesce(name,'')), 'B');

		      CREATE INDEX firms_full_text_idx ON firms USING gin(full_text);
		eosql
  end

  def down
   execute(<<-'eosql'.strip)
      DROP INDEX IF EXISTS firms_full_text_idx;
      DROP TRIGGER IF EXISTS tsvector_firms_upsert_trigger ON firms;
      DROP FUNCTION IF EXISTS firms_generate_tsvector();
      ALTER TABLE firms DROP COLUMN full_text;
    eosql
  end
end
