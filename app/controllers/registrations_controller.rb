class RegistrationsController < Devise::RegistrationsController
  def new
    super do |resource|
      resource.tenants.build
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, tenants_attributes: [:id, :plan, :plan_id])
  end
end
