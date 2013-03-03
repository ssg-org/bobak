class CreateSummaryTables < ActiveRecord::Migration
  def up
  	create_table :bank_summaries do |t|
  		t.date		:date
  		t.integer :blocked_accounts
      t.integer :blocked_owners

  		t.references :bank
  	end

  	create_table :owner_summaries do |t|
  		t.date 		:date
  		t.integer	:blocked_accounts

  		t.references :owner
  	end

  	BankSummary.reset_column_information
  	OwnerSummary.reset_column_information

    owners_per_bank = Owner.select([:bank_id, :date]).joins(:accounts => :account_statuses).group(:bank_id, :date).count
    owners_per_bank.each do |bank|
      BankSummary.create(:bank_id => bank[0][0], :date => bank[0][1], :blocked_owners => bank[1])
    end

  	accounts_per_bank = Account.select([:bank_id, :date]).joins(:account_statuses).group(:bank_id, :date).count
  	accounts_per_bank.each do |bank|
      summary = BankSummary.where(:bank_id => bank[0][0], :date => bank[0][1]).first
      summary.blocked_accounts = bank[1]
      summary.save!
  	end

  	accounts_per_owner = Account.select([:owner_id, :date]).joins(:account_statuses).group(:owner_id, :date).count
  	accounts_per_owner.each do |owner|
  		OwnerSummary.create(:owner_id =>owner[0][0], :date => owner[0][1], :blocked_accounts => owner[1])
  	end

  	add_index :bank_summaries, [:bank_id, :date]
  	add_index :owner_summaries, [:owner_id, :date]
  end

  def down
  	drop_table 	:bank_summaries
  	drop_table	:owner_summaries
  end
end
