require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'バリデーション' do
    it '設定したすべてのバリデーションが機能しているか' do
      article = build(:article)
      expect(article).to be_valid
      expect(article.thumbnail).to be_attached
    end

    it 'タイトルがない場合失敗' do
      article = build(:article, title: nil)
      expect(article).not_to be_valid
      expect(article.errors[:title]).to include("can't be blank")
    end

    it 'サムネイルがなくても投稿できる' do
      article = build(:article, thumbnail: nil)
      expect(article).to be_valid
    end
  end
end