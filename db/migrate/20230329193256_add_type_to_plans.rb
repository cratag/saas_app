class AddTypeToPlans < ActiveRecord::Migration[6.0]
  def change
    add_column :plans, :type, :int
  end
end
