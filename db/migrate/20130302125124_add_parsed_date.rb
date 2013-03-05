class AddParsedDate < ActiveRecord::Migration
	class AccountStatus < ActiveRecord::Base
	end

	class OwnerSummary < ActiveRecord::Base
	end

	class BankSummary < ActiveRecord::Base
	end

  def up
    add_column :account_statuses, :year, :Integer
    add_column :account_statuses, :month, :Integer
    add_column :account_statuses, :day, :Integer

    add_column :owner_summaries, :year, :Integer
    add_column :owner_summaries, :month, :Integer
    add_column :owner_summaries, :day, :Integer

    add_column :bank_summaries, :year, :Integer
    add_column :bank_summaries, :month, :Integer
    add_column :bank_summaries, :day, :Integer

    AccountStatus.reset_column_information
    OwnerSummary.reset_column_information
    BankSummary.reset_column_information

    condition = "year=date_part('year', date), month=date_part('month', date), day=date_part('day', date)"

    AccountStatus.update_all(condition)
    OwnerSummary.update_all(condition)
    BankSummary.update_all(condition)

    # recreate indexes
		remove_index :bank_summaries, [:bank_id, :date]
  	remove_index :owner_summaries, [:owner_id, :date]

  	add_index	:account_statuses, [:account_id, :year, :month]
		add_index :bank_summaries, [:bank_id, :year, :month]
  	add_index :owner_summaries, [:owner_id, :year, :month]
  end

  def down
  	remove_column :account_statuses, :year
  	remove_column :account_statuses, :month
  	remove_column :account_statuses, :day

  	remove_column :owner_summaries, :year
  	remove_column :owner_summaries, :month
  	remove_column :owner_summaries, :day
  	
  	remove_column :bank_summaries, :year
  	remove_column :bank_summaries, :month
  	remove_column :bank_summaries, :day

  	remove_index	:account_statuses, [:account_id, :year, :month]
		remove_index	:bank_summaries, [:bank_id, :year, :month]
  	remove_index 	:owner_summaries, [:owner_id, :year, :month]

		add_index :bank_summaries, [:bank_id, :date]
  	add_index :owner_summaries, [:owner_id, :date]
  end
end
