class Tag < ApplicationRecord
  has_many :article_tags, dependent: :destroy
  has_many :articles, through: :article_tags
  validates :name, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end
end
