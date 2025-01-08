class FavoritesController < ApplicationController
  before_action :set_article

  def create
    @favorite = current_user.favorites.new(article: @article)
    @favorite.save
    redirect_to @article
  end

  def destroy
    @favorite = current_user.favorites.find_by(article: @article)
    @favorite.destroy
    redirect_to @article
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end
end