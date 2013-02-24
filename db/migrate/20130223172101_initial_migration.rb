class InitialMigration < ActiveRecord::Migration
  def up
		create_table :account_statuses, :force => true do |t|
		    t.integer  	:account_id
		    t.date 			:date
		    t.integer		:status

		   	t.timestamps
		  end

		  create_table :accounts do |t|
		    t.string   :number
		    t.text   	 :name
		    t.integer  :bank_id
		    t.integer  :owner_id

		    t.timestamps
		  end

		  create_table :banks do |t|
		    t.string   :name
		    t.string   :city

		    t.timestamps
		  end

		  create_table :owners do |t|
		    t.string   :oid
		    t.text   :name
		    t.string   :city
		    t.string   :address

		    t.timestamps
		  end

	    execute "CREATE EXTENSION pg_trgm;"  	
			
			execute(<<-'eosql'.strip)
			      ALTER TABLE owners ADD COLUMN full_text tsvector;

			      CREATE FUNCTION owners_generate_tsvector() RETURNS trigger AS $$
			        begin
			          new.full_text :=
			            setweight(to_tsvector('pg_catalog.english', coalesce(new.oid,'')), 'A') ||
			            setweight(to_tsvector('pg_catalog.english', coalesce(new.name,'')), 'B');
			          return new;
			        end
			      $$ LANGUAGE plpgsql;

			      CREATE TRIGGER tsvector_owners_upsert_trigger BEFORE INSERT OR UPDATE
			        ON owners
			        FOR EACH ROW EXECUTE PROCEDURE owners_generate_tsvector();

			      UPDATE owners SET full_text =
			        setweight(to_tsvector('pg_catalog.english', coalesce(oid,'')), 'A') ||
			        setweight(to_tsvector('pg_catalog.english', coalesce(name,'')), 'B');

			      CREATE INDEX owners_full_text_idx ON owners USING gin(full_text);
			      CREATE INDEX owners_trigram_idx ON owners USING gist(name gist_trgm_ops);
			eosql
  end

  def down
    #execute "DROP EXTENSION pg_trgm;"
    drop_table :owners
    drop_table :accounts
    drop_table :account_statuses
    drop_table :banks

    execute(<<-'eosql'.strip)
	    DROP FUNCTION owners_generate_tsvector();
    eosql
  end
end
