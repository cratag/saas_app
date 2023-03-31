class AddNameToTenants < ActiveRecord::Migration[6.0]
  def change
    add_column :tenants, :name, :string
  end
end
