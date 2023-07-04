class CreateScheduleTable < ActiveRecord::Migration[6.1]
  def change
    create_table :schedules do |t|
      t.string "theather_name"
      t.datetime "date_time"
      t.string "title"
      t.string "movie_format"
      t.text "image_url"
      t.text "description"
      t.text "url"
      t.string "slug"
      t.string "original_id"
      
      t.timestamps
    end
  end
end
