class CreateGoals < ActiveRecord::Migration[7.1]
  def change
    create_table :goals, id: :uuid do |t|
      t.string :name
      t.float :target_amount
      t.float :current_amount
      t.datetime :target_date
      t.float :saved_value
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
