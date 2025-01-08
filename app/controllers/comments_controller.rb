class CommentsController < ApplicationController
  before_action :set_article
  before_action :set_article, only: [:create, :edit, :update, :destroy]
  before_action :set_comment, only: [:edit, :update, :destroy]

  def create
    @comment = @article.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @article, success: "コメントを投稿しました"
    else
      redirect_to @article, danger: "コメントの投稿に失敗しました"
    end
  end

  def edit
  end

  def update
    @comment = @article.comments.find(params[:id])
    if @comment.update(comment_params)
      redirect_to @article, success: "コメントを更新しました"
    else
      flash.now[:danger] = "コメントの更新に失敗しました"
      render "articles/show"
    end
  end

  def destroy
    @comment.destroy
    redirect_to @article, danger: "コメントを削除しました"
  end

  private

  def set_comment
    @comment = @article.comments.find(params[:id])
  end

  def set_article
    @article = Article.find(params[:article_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end