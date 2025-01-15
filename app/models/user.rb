class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_articles, through: :bookmarks, source: :article

  def own?(object)
    id == object&.user_id
  end

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true

  def bookmark(article)
    bookmark_articles << article
  end

  def unbookmark(article)
    bookmark_articles.destroy(article)
  end

  def bookmark?(article)
    bookmark_articles.include?(article)
  end
end
