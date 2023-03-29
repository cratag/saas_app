class AddUserToTenants < ActiveRecord::Migration[6.0]
  def change
    add_reference :tenants, :user, null: false, foreign_key: true
  end
end
