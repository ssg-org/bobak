class CreateAccountStatuses < ActiveRecord::Migration
  def change
    create_table :account_statuses do |t|
      t.integer :account_id
      t.timestamp :date

      t.timestamps
    end
  end
end
