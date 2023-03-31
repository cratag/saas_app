class AddOrganizationNameToTenants < ActiveRecord::Migration[6.0]
  def change
    add_column :tenants, :organization, :string
  end
end
