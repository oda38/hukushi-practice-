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
      user.telephone_number = '9999999999'
    end
  end
  
  
  
  
  #退会済みユーザーのログイン制約
  def active_for_authentication?
    super && (is_deleted == false)
  end
  
  
  has_many :posts, dependent: :destroy  
  
  
  
  has_one_attached :profile_image
  
  def get_profile_image
    unless profile_image.attached?
      file_path = Rails.root.join('hukucity/app/assets/images/no_image_irasutoya.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

end
