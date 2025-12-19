class User < ApplicationRecord
  has_secure_password
  
  # Associations
  has_one :influencer_profile, dependent: :destroy
  has_one :subscriber_profile, dependent: :destroy
  
  # Enums
  enum :user_type, { subscriber: 0, influencer: 1 }
  
  # Validations
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  validates :user_type, presence: true
  
  # Callbacks
  before_save :downcase_email
  after_create :create_user_profile
  
  # Scopes
  scope :influencers, -> { where(user_type: :influencer) }
  scope :subscribers, -> { where(user_type: :subscriber) }
  
  private
  
  def downcase_email
    self.email = email.downcase
  end
  
  def create_user_profile
    if influencer?
      create_influencer_profile!
    else
      create_subscriber_profile!
    end
  end
end
