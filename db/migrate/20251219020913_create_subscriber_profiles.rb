class CreateSubscriberProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriber_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.text :dietary_preferences

      t.timestamps
    end
  end
end