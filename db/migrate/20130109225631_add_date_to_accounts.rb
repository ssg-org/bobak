class AddDateToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :date, :datetime
  end
end
