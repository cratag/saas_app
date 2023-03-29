class ApplicationController < ActionController::Base
  before_action :set_current_tenant

  private

  def set_current_tenant
    ActsAsTenant.current_tenant = current_account
  end

  def current_account
    current_user.tenant
  end
end
