require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @user = create(:user)
    @article = create(:article)
  end

  describe "バリデーション" do
    it "本文がある場合投稿できる" do
      comment = build(:comment, user_id: @user.id, article_id: @article.id)
      expect(comment).to be_valid
    end

    it "本文がない場合投稿できない" do
      comment = build(:comment, body: nil, user_id: @user.id, article_id: @article.id)
      expect(comment).not_to be_valid
    end  
  end
end