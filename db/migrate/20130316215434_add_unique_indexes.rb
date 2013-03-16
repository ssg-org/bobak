class AddUniqueIndexes < ActiveRecord::Migration
  def change
    add_index :owners,    [:oid],     :unique => true
    add_index :accounts,  [:number],  :unique => true
  end
end
