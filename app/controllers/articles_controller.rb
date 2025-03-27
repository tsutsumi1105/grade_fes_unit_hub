class ArticlesController < ApplicationController
  skip_before_action :require_login, only: %i[index show autocomplete_title autocomplete_user_name autocomplete_tags_name]

  def index
    @q = Article.ransack(params[:q])
    @articles = @q.result.includes(:user, :tags).where(status: 1).order(created_at: :desc).page(params[:page]).per(12)
  end

  def new
    @article = Article.new
    @tag_names = @article.tags.pluck(:name).join(",")
  end

  def create
    @article = current_user.articles.build(article_params)
    
    #@article.title = ActionController::Base.helpers.sanitize(@article.title)

    tag_names = params[:article][:tags].split(",").map(&:strip).map { |tag| ActionController::Base.helpers.sanitize(tag) }

=begin
    if tag_names.any? { |tag| tag.match?(/<script.*?>.*?<\/script>/i) }
      flash.now[:danger] = "タグに不正なスクリプトが含まれています"
      render :new, status: :unprocessable_entity and return
    end

    if !@article.save_tags(tag_names)
      flash.now[:danger] = "タグに不正なスクリプトが含まれています"
      render :new, status: :unprocessable_entity and return
    end
=end
    
    if params[:draft]
      @article.status = 0
    else
      @article.status = 1
    end

    if @article.save
      @article.save_tags(tag_names)
      if params[:draft]
        redirect_to mypage_path, success: "下書きに保存しました"
      else
        redirect_to root_path, success: "記事を投稿しました"
      end
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
    
    #@article.title = ActionController::Base.helpers.sanitize(@article.title)
    
    tag_names = params[:article][:tags].split(",").map(&:strip).map { |tag| ActionController::Base.helpers.sanitize(tag) }
=begin
    if tag_names.any? { |tag| tag.match?(/<script.*?>.*?<\/script>/i) }
      flash.now[:danger] = "タグに不正なスクリプトが含まれています"
      render :edit, status: :unprocessable_entity and return
    end
=end

    if params[:draft]
      @article.status = 0
    else
      @article.status = 1
    end

    if @article.update(article_params)
      @article.save_tags(tag_names)
      if params[:draft]
        redirect_to mypage_path, success: "下書きに保存しました"
      else
        redirect_to root_path, success: "記事を投稿しました"
      end
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

  def autocomplete_title
    @articles = Article.where("title LIKE ?", "%#{params[:term]}%").limit(10)
    render json: @articles.pluck(:title)
  end

  def autocomplete_user_name
    @users = User.where("name LIKE ?", "%#{params[:term]}%").pluck(:name)
    render json: @users
  end

  def autocomplete_tags_name
    @tags = Tag.where("name LIKE ?", "%#{params[:term]}%").pluck(:name)
    render json: @tags
  end

  private

  def article_params
    sanitized_params = params.require(:article).permit(:title, :body, :status, :thumbnail)
    sanitized_params[:title] = ActionController::Base.helpers.sanitize(sanitized_params[:title])
    sanitized_params
  end
end