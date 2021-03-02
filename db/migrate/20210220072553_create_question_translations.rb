class CreateQuestionTranslations < ActiveRecord::Migration[6.1]
  def change
    create_table :question_translations do |t|
      t.integer :question_id
      t.string :lang
      t.string :content
      t.timestamps
    end
  end
end
