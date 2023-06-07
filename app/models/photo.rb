class Photo < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  after_save :attach_image_url
  has_many :comments

  def attach_image_url
    self.update_column(:file_url, self.image.service_url) unless self.file_url.present?
  end

  def public_image_url
    self.image.service_url.sub(/\?.*/, "")
  end
end
