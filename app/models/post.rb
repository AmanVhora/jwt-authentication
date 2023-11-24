class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  validates :images, :caption, presence: true
end
