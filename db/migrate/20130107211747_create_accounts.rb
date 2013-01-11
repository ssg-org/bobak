class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :number
      t.integer :bank_id
      t.integer :firm_id

      t.timestamps
    end
  end
end
