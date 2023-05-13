class Repository < ApplicationRecord
  validates :name, :description, presence: true
end
