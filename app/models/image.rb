class Image < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :ref_image, polymorphic: true

  validates_processing_of :image
  validate :image_size_validation

  private
  def image_size_validation
    errors[:image] << "should be less than 1024KB" if image.size > 1.megabytes
  end
end
