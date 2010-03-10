class CreateSubmissions < ActiveRecord::Migration
  def self.up
    create_table :submissions do |t|
      t.string :video_url
      t.string :name
      t.string :email
      t.string :address
      t.text :text
      t.float :lat
      t.float :lng
      t.datetime :approved_at

      t.timestamps
    end
  end

  def self.down
    drop_table :submissions
  end
end
