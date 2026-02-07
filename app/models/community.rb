class Community < ApplicationRecord
  belongs_to :user
  has_many :submissions

  validates :title, presence: true
  validates :body, length: { maximum: 8000 }
end
