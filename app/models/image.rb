class Image < ApplicationRecord
  belongs_to :ref_image, polymorphic: true
end
