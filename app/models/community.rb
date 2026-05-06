class Community < ApplicationRecord
  belongs_to :user
  has_many :submissions

  has_many :subscriptions
  has_many :users, through: :subscriptions

  validates :title, presence: true
  validates :description, length: { maximum: 8000 }
end
