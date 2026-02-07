class Submission < ApplicationRecord
  belongs_to :user
  belongs_to :community
  has_one_attached :media
end
