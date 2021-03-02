class CreateMemos < ActiveRecord::Migration[6.1]
  def change
    create_table :memos do |t|
      t.integer :user_id
      t.integer :question_id
      t.boolean :is_public, default: false
      t.text :content
      t.integer :likes
      t.timestamps
    end
  end
end
