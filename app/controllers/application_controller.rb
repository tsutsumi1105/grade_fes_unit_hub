class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

  before_action :require_login

  add_flash_types :success, :danger

  private

  def not_authenticated
    redirect_to login_path
  end

  def handle_not_found
    redirect_to root_path, alert: "存在しないページです"
  end
end
