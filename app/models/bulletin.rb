# frozen_string_literal: true

class Bulletin < ApplicationRecord
  include AASM

  belongs_to :category
  belongs_to :user

  has_one_attached :image

  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  validates :description, presence: true, length: { minimum: 100, maximum: 1000 }
  validates :image,
            attached: true,
            content_type: ['image/png', 'image/jpeg'],
            size: { less_than: 5.megabytes }

  aasm column: :state, whiny_transitions: false do
    state :draft, initial: true
    state :under_moderation, :published, :rejected, :archived

    event :to_moderate do
      transitions from: :draft, to: :under_moderation
    end

    event :reject do
      transitions from: :under_moderation, to: :rejected
    end

    event :publish do
      transitions from: :under_moderation, to: :published
    end

    event :archive do
      transitions from: %i[published under_moderation rejected draft], to: :archived
    end
  end
end
