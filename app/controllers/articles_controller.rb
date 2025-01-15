class ArticlesController < ApplicationController
  skip_before_action :require_login, only: %i[index show]

  def index
    @articles = Article.includes(:user, :tags).order(created_at: :desc)
  end

  def new
    @article = Article.new
    @tag_names = @article.tags.pluck(:name).join(",")
  end

  def create
    @article = current_user.articles.build(article_params)
    tag_names = params[:article][:tags].split(",").map(&:strip)
    if @article.save
      @article.save_tags(tag_names)
      redirect_to articles_path, success: "記事を投稿しました"
    else
      flash.now[:danger] = "記事の投稿に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @article = Article.find(params[:id])
    @comment = Comment.new
    @comments = @article.comments.includes(:user).order(created_at: :asc)
  end

  def edit
    @article = current_user.articles.find(params[:id])
    @tag_names = @article.tags.pluck(:name).join(",")
  end

  def update
    @article = current_user.articles.find(params[:id])
    tag_names = params[:article][:tags].split(",").map(&:strip)
    if @article.update(article_params)
      @article.save_tags(tag_names)
      redirect_to article_path(@article), success: "記事を更新しました"
    else
      flash.now[:danger] = "記事の更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = current_user.articles.find(params[:id])
    @article.destroy
    redirect_to articles_path, danger: "削除しました", status: :see_other
  end

  def tags
    @tags = Tag.all
  end

  def bookmarks
    @bookmark_articles = Current.user.bookmark_articles.includes(:user).order(created_at: :desc)
  end

  private

  def article_params
    params.require(:article).permit(:title, :body)
  end
end