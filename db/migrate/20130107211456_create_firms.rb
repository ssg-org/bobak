class CreateFirms < ActiveRecord::Migration
  def change
    create_table :firms do |t|
      t.integer :jib
      t.string :name
      t.string :city

      t.timestamps
    end
  end
end
