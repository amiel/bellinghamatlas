class AddFeatudedToSubmissions < ActiveRecord::Migration
  def self.up
    add_column :submissions, :featured, :boolean
  end

  def self.down
    remove_column :submissions, :featured
  end
end
