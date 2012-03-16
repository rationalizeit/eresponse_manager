class CreateDownloads < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
     t.date :class_at 
     t.integer :last_uid

      t.timestamps
    end
  end
end
