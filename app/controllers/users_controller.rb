class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create show mypage]
  before_action :set_user, only: %i[edit update mypage]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, success: "ユーザー登録が完了しました"
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @articles = @user.articles.order(created_at: :desc)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to mypage_path, success: 'ユーザー情報を更新しました'
    else
      render :edit, danger: '更新できませんでした'
    end
  end

  def mypage
    @user = current_user
    @articles = @user.articles.order(created_at: :desc)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = current_user
  end
end