class Post < ApplicationRecord
  
  validates :title, presence: true, on: :publicize
  validates :content, presence: true, on: :publicize
  
  
  has_one_attached :image
  has_many_attached :addition_images
  
  def get_image
    unless image.attached?
      file_path = Rails.root.join('hukucity/app/assets/images/no_image_irasutoya.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_limit: [width, height]).processed
  end
  
  validates :image, presence: true, on: :publicize
  validate :validate_number_of_files
  
  def validate_number_of_files
    return if addition_images.length <= 4
    errors.add(:addition_images, "に入力できる画像は4つまでです。")
  end
  
  
  belongs_to :user
 
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  def save_tag(sent_tags)
  # タグが存在していれば、タグの名前を配列として全て取得
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # 現在取得したタグから送られてきたタグを除いてoldtagとする
    old_tags = current_tags - sent_tags
    # 送信されてきたタグから現在存在するタグを除いたタグをnewとする
    new_tags = sent_tags - current_tags

    # 古いタグを消す
    old_tags.each do |old|
      self.tags.delete Tag.find_by(name: old)
    end

    # 新しいタグを保存
    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(name: new)
      self.tags << new_post_tag
   end
  end
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  def self.looks(search, keyword)
    if search == "perfect_match"
      @post = Post.where("title LIKE?", "#{keyword}")
    elsif search == "partial_match"
      @post = Post.where("title LIKE?","%#{keyword}%")
    else
      @post = Post.all
    end
  end
  
  
end
