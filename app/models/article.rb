class Article < ApplicationRecord
  has_one_attached :thumbnail
  has_rich_text :body
  
  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }

  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :article_tags, dependent: :destroy
  has_many :tags, through: :article_tags
  has_many :bookmarks, dependent: :destroy

  belongs_to :user

  enum status: { draft: 0, published: 1 }

  def favorited_by?(user)
    favorites.exists?(user: user)
  end

  def save_tags(tag_names)
    self.tags.clear
    tag_names.each do |tag_name|
      tag = Tag.find_or_create_by(name: tag_name)
      self.tags << tag
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["title", "body"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["tags", "user"]
  end
end
