class CreateFollows < ActiveRecord::Migration[6.1]
  def change
    create_table :follows do |t|
      t.integer :target_user_id
      t.integer :user_id
      t.timestamps
    end
  end
end
