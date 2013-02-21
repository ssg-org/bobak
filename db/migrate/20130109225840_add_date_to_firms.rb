class AddDateToFirms < ActiveRecord::Migration
  def change
    add_column :firms, :date, :datetime
  end
end
