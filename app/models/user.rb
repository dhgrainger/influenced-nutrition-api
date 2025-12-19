class User < ApplicationRecord
  has_secure_password validations: false
  
  # Associations
  has_one :influencer_profile, dependent: :destroy
  has_one :subscriber_profile, dependent: :destroy
  
  # Enums
  enum :user_type, { subscriber: 0, influencer: 1 }
  
  # Validations
  validates :email, presence: true, uniqueness: { case_sensitive: false }, if: :email_required?
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, if: :email_required?
  validates :name, presence: true
  validates :password, length: { minimum: 6 }, if: :password_required?
  validates :user_type, presence: true
  
  # Instagram OAuth validations
  validates :uid, uniqueness: { scope: :provider }, if: -> { uid.present? }
  
  # Callbacks
  before_save :downcase_email, if: :email_required?
  after_create :create_user_profile
  
  # Scopes
  scope :influencers, -> { where(user_type: :influencer) }
  scope :subscribers, -> { where(user_type: :subscriber) }
  scope :with_instagram, -> { where.not(provider: nil) }
  
  # OmniAuth Methods
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email if auth.info.email
      user.name = auth.info.name || auth.info.nickname
      user.instagram_username = auth.info.nickname
      user.instagram_token = auth.credentials.token
      user.token_expires_at = Time.at(auth.credentials.expires_at) if auth.credentials.expires_at
      user.user_type = :influencer # Default Instagram users to influencers
      user.password = SecureRandom.hex(16) # Random password for OAuth users
    end
  end
  
  def instagram_connected?
    provider == 'instagram_graph' && uid.present?
  end
  
  def instagram_token_valid?
    instagram_connected? && token_expires_at && token_expires_at > Time.current
  end
  
  private
  
  def downcase_email
    self.email = email.downcase if email.present?
  end
  
  def create_user_profile
    if influencer?
      create_influencer_profile!
    else
      create_subscriber_profile!
    end
  end
  
  def email_required?
    provider.blank?
  end
  
  def password_required?
    provider.blank? && (new_record? || password.present?)
  end
end