class CreateUserSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :user_settings do |t|
      t.integer :user_id
      t.string :lang
      t.boolean :is_reminder_on
      t.boolean :is_public 
      t.integer :alarm_time_int #in UTC
      t.timestamps
    end
  end
end
