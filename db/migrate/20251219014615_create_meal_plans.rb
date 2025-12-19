class CreateMealPlans < ActiveRecord::Migration[8.1]
  def change
    create_table :meal_plans do |t|
      t.references :influencer, null: false, foreign_key: true
      t.string :title
      t.decimal :price

      t.timestamps
    end
  end
end
