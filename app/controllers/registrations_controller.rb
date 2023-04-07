class RegistrationsController < Devise::RegistrationsController
  def new
    super do |resource|
      resource.tenants.build
    end
  end

  # Override default Devise create behaviour.
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        create_payment_record(resource) # Create payment record for User.
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, tenants_attributes: [:id, :plan, :plan_id, :name])
  end

  def create_payment_record(resource)
    begin
      return unless params[:user][:tenants_attributes]["0"][:plan_id].to_i != 2
      payment = Payment.find_or_initialize_by(tenant_id: resource.tenants.first.id)
      payment.email = params[:user][:email]
      payment.token = params[:payment][:token]
      payment.save!
    rescue Exception => e
      puts e
      redirect_to root_path
    end
  end
end
