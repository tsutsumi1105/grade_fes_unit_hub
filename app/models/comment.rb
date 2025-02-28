class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article

  validates :body, presence: true
  validates :user_id, presence: true
  validates :article_id, presence: true
  #validate :no_xss_input

=begin
  def no_xss_input
    if body&.match?(/<script.*?>.*?<\/script>/i)
      errors.add(:body, "不正なスクリプトを含めることはできません")
    end
  end
=end
end
