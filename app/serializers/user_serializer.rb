class UserSerializer
  def initialize(user)
    @user = user
  end
  
  def as_json
    {
      id: @user.id,
      email: @user.email,
      name: @user.name,
      user_type: @user.user_type,
      created_at: @user.created_at,
      profile: profile_data
    }
  end
  
  private
  
  def profile_data
    if @user.influencer?
      {
        type: 'influencer',
        bio: @user.influencer_profile&.bio,
        instagram_handle: @user.influencer_profile&.instagram_handle,
        follower_count: @user.influencer_profile&.follower_count,
        commission_rate: @user.influencer_profile&.commission_rate&.to_f
      }
    else
      {
        type: 'subscriber',
        dietary_preferences: @user.subscriber_profile&.dietary_preferences
      }
    end
  end
end
