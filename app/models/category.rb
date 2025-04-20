# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :bulletins

  validates :name, presence: true, uniqueness: true, length: { minimum: 5, maximum: 50 }
end
