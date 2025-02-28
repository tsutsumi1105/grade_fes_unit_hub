class Article < ApplicationRecord
  has_one_attached :thumbnail
  has_rich_text :body
  has_one :body, class_name: 'ActionText::RichText', as: :record
  
  validates :title, presence: true, length: { maximum: 255 }
  validate :body_text_validation
  validate :no_xss_input
  #before_save :sanitize_body

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
      
      if tag.valid? && !tag.name.match?(/<script.*?>/i)
        self.tags << tag
      else
        errors.add(:tags, "不正なスクリプトが含まれています")
        return false
      end
    end
    true
  end

  def self.ransackable_attributes(auth_object = nil)
    ["title", "body"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["tags", "user"]
  end

  def body_text_validation
    if body&.to_plain_text.blank? || body&.to_plain_text.length > 65_535
      errors.add(:body)
    end
  end

=begin
  def sanitize_body
    self.body = ActionController::Base.helpers.sanitize(body.to_s, tags: %w[b i u em strong a p br])
  end
=end

  def no_xss_input
    if body&.to_plain_text.match?(/<script.*?>.*?<\/script>/i)
      errors.add(:body, "不正なスクリプトを含めることはできません")
    end
  end
=begin
    if title&.match?(/<script.*?>.*?<\/script>/i)
      errors.add(:title, "不正なスクリプトを含めることはできません")
    end
  end
=end
end