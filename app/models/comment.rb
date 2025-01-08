class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article

  validates :body, presence: true
  validates :user_id, presence: true
  validates :article_id, presence: true
end
