class CommentsController < ApplicationController
  before_action :set_article

  def create
    @comment = @article.comments.build(comment_params)
    @comment.user = current_user # 現在のユーザーをコメントの作成者として設定

    if @comment.save
      redirect_to @article, notice: "コメントを投稿されました"
    else
      redirect_to @article, alert: "コメントの投稿に失敗しました"
    end
  end

  def edit
    @comment = @article.comments.find(params[:id])
  end

  def update
    @comment = current_user.comments.find(params[:id])
    if @comment.update(comment_params)
      redirect_to article_path(@article), success: "コメントを編集しました"
    else
      flash.now[:danger] = "コメントの投稿に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    redirect_to @article, alert: "コメントを削除しました"
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end