class AddTenantsToUser < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :tenant, foreign_key: true
  end
end
