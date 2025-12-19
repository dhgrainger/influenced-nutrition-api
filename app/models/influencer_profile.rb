class InfluencerProfile < ApplicationRecord
  belongs_to :user
  
  validates :commission_rate, numericality: { 
    greater_than_or_equal_to: 0, 
    less_than_or_equal_to: 100 
  }, allow_nil: true
  
  validates :follower_count, numericality: { 
    greater_than_or_equal_to: 0 
  }, allow_nil: true
end