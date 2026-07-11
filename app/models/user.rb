class User < ApplicationRecord
  before_create :add_unsubscribe_hash

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :communities
  has_many :submissions, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :subscriptions
  has_many :communities, through: :subscriptions

  has_many :subscribed_submissions, through: :communities, source: :submissions

  validates_uniqueness_of :username
  validates_presence_of :username

  acts_as_voter

  private

    def add_unsubscribe_hash
      unsubscribe_hash = SecureRandom.hex
    end
end
