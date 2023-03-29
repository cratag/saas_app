class RenameTypeToPlanTypeInPlans < ActiveRecord::Migration[6.0]
  def change
    rename_column :plans, :type, :plan_type
  end
end
