class AddNameIndex < ActiveRecord::Migration
  def up
    add_index :owners, [:name, :id]
  end

  def down
    remove_index :owners, [:name, :id]
  end
end
