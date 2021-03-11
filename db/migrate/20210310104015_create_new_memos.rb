class CreateNewMemos < ActiveRecord::Migration[6.1]
  def change
    create_table :new_memos do |t|
      #table's name! NewMemo -> new_memos #
      t.integer :user_id #foreign_key 
      t.integer :question_id
      t.text :content #
      #database colukn type
      t.timestamps
    end
  end
end
