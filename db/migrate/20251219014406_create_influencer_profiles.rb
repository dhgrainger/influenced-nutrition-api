class CreateInfluencerProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :influencer_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.text :bio
      t.string :instagram_handle
      t.integer :follower_count
      t.decimal :commission_rate, precision: 5, scale: 2

      t.timestamps
    end
    
    add_index :influencer_profiles, :instagram_handle
  end
end
