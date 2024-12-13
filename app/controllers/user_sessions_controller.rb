class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new; end

  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_to root_path, notice: "ログインしました。"
    else
      render :new
    end
  end

  def destroy
    logout
    redirect_to login_path, notice: "ログアウトしました。", status: :see_other
  end
end