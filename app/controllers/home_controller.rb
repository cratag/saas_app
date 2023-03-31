class HomeController < ApplicationController
  def index
    if current_user
      @tenant
      if session[:tenant_id]
        @tenant = Tenant.find(session[:tenant_id])
      else
        @tenant = current_user.tenants.first
      end

      @projects = Project.by_plan_and_tenant(@tenant.id)
      params[:tenant_id] = @tenant.id
    end
  end
end
