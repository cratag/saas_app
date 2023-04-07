class TenantsController < ApplicationController
  before_action :set_tenant

  def edit
  end

  def update
    set_tenant
    return unless @tenant
    respond_to do |format|
      if @tenant.update(tenant_params)
        if @tenant.plan_id == 2 && @tenant.payment.blank?
          @payment = Payment.new({ email: tenant_params["email"],
            token: params[:payment]["token"],
            tenant: @tenant })
          begin
            @payment.process_payment
            @payment.save
          rescue Exception => e
            flash[:error] = e.message
            @payment.destroy
            @tenant.plan = 1
            @tenant.save

            redirect_to edit_tenant_path(@tenant) and return
          end
        end
        format.html { redirect_to edit_plan_path, notice: "Plan was successfully updated" }
      else
        format.html { render :edit }
      end
    end
  end
  private
  def set_tenant
    @tenant = Tenant.find(current_user.tenants.first.id)
  end

  def tenant_params
    params.require(:tenant).permit(:name, :plan_id)
  end
end
