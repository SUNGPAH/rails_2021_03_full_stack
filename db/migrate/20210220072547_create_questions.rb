class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.string :content
      t.integer :date #20210225 #for instance.
      t.timestamps
    end
  end
end
