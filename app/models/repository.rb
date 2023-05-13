class Repository < ApplicationRecord
  validates :name, presence: true
end
