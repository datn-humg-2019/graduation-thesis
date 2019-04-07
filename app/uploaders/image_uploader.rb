class ImageUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  version :big do
    process resize_to_fill: [500, 500]
  end

  version :standard do
    process resize_to_fill: [350, 250]
  end

  version :thumb do
    process resize_to_fill: [150, 150]
  end

  def default_public_id
    "default"
  end
end
