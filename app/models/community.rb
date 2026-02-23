class Community < ApplicationRecord
  belongs_to :user
  has_many :submissions

  validates :title, presence: true
  validates :description, length: { maximum: 8000 }
end
