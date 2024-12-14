class ArticlesController < ApplicationController
  skip_before_action :require_login, only: %i[index]

  def index
    @articles = Article.includes(:user)
  end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      redirect_to articles_path, success: "記事を投稿しました。"
    else
      flash.now[:danger] = "記事の投稿に失敗しました。"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @article = Article.find(params[:id])
  end

  private

  def article_params
    params.require(:article).permit(:title, :body)
  end
end