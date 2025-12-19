class AddOathToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :instagram_username, :string
    add_column :users, :instagram_token, :string
    add_column :users, :token_expires_at, :datetime
    
    add_index :users, [:provider, :uid], unique: true
    add_index :users, :instagram_username
    
    # Make email nullable for OAuth users
    change_column_null :users, :email, true
    
    # Make password_digest nullable for OAuth users  
    change_column_null :users, :password_digest, true
  end
end

