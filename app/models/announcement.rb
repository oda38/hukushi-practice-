class Announcement < ApplicationRecord
  has_one_attached :announcement_image
  
  validates :title, presence: true
  validates :announcement_image, presence: true
  validates :content, presence: true
end
