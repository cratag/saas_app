class Tenant < ApplicationRecord
  belongs_to :user
  has_one :plan

  attr_accessor :plan_id

  before_validation :set_plan_from_plan_id

  private

  def set_plan_from_plan_id
    self.plan = Plan.find_by(id: plan_id) if plan_id.present?
  end
end
