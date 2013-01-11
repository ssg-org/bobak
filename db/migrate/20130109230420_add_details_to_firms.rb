class AddDetailsToFirms < ActiveRecord::Migration
  def change
    add_column :firms, :mbs, :string
    add_column :firms, :name_short, :string
    add_column :firms, :address, :string
    add_column :firms, :type, :string
    add_column :firms, :is_insolvent, :boolean
    add_column :firms, :customs_num, :string
  end
end
