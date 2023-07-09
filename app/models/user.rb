class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = 'ゲスト'
      user.name_kana = 'ゲスト' 
      user.nickname = 'ゲスト'
      user.telephone_number = '00000000001' 
    end
  end
  
  #退会済みユーザーのログイン制約
  def active_for_authentication?
    super && (is_deleted == false)
  end
  
  validates :name, presence: true
  validates :name_kana, presence: true, format: { with: /\A[ァ-ヴー]+\z/u }
  validates :nickname, presence: true
  validates :telephone_number, presence: true, format: { with: /\A\d{10,11}\z/ }
  
  

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  has_one_attached :profile_image
  
  def get_profile_image
    unless profile_image.attached?
      file_path = Rails.root.join('hukucity/app/assets/images/no_image_irasutoya.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
  
  
  def self.looks(search, keyword)
    if search == "perfect_match"
      @user = User.where("nickname LIKE?", "#{keyword}")
    elsif search == "partial_match"
      @user = User.where("nickname LIKE?","%#{keyword}%")
    else
      @user = User.all
    end
  end
  

end
