class TagsController < ApplicationController
  skip_before_action :require_login

  def show
    @tag = Tag.find(params[:id])
    @articles = @tag.articles.includes(:user).order(created_at: :desc)
  end
end