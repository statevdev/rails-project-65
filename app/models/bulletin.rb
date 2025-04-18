# frozen_string_literal: true

class Bulletin < ApplicationRecord
  belongs_to :category
  belongs_to :user

  has_one_attached :image

  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  validates :description, presence: true, length: { minimum: 100, maximum: 1000 }
  validates :image,
            attached: true,
            content_type: ['image/png', 'image/jpeg'],
            size: { less_than: 5.megabytes }
end
