class Submission < ApplicationRecord
  include VotesCountable
  belongs_to :user
  belongs_to :community
  has_one_attached :media
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :body, length: { maximum: 8000 }
  validates :url, url: true, allow_blank: true
  validate :body_or_url
  validate :content_exists

  acts_as_votable

  private

    def body_or_url
      unless url.blank? || body.blank?
        unless url.blank? ^ body.blank?
          errors.add(:base, "Add a valid URL or text content")
        end
      end
    end

    def content_exists
      if url.blank? && body.blank? && !media.attached?
        errors.add(:base, "Add content to continue")
      end
    end
end
