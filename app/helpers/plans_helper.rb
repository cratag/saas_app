module PlansHelper
  def plan_id_from_param(plan_param)
    return unless plan_param
    plan_id = Plan.options.find { |option| option[0] == plan_param.downcase.capitalize }
    plan_id ? plan_id[1] : nil
  end
end