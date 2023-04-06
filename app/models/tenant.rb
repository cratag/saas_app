class Tenant < ApplicationRecord
  belongs_to :user
  has_one :plan
  has_many :projects, dependent: :destroy
  has_one :payment
  accepts_nested_attributes_for :payment

  attr_accessor :plan_id
  before_validation :set_plan_from_plan_id

  def can_create_projects?
    (plan.plan_type == 1 && projects.count < 1) || (plan.plan_type == 2)
  end

  private
  def set_plan_from_plan_id
    self.plan = Plan.find_by(id: plan_id) if plan_id.present?
  end
end
