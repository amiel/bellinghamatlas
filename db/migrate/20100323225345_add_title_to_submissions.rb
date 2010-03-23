class AddTitleToSubmissions < ActiveRecord::Migration
  def self.up
    add_column :submissions, :title, :string
    
    Submission.all.each do |s|
      s.update_attribute :title, "#{s.text[0..15]}..."
    end
  end

  def self.down
    remove_column :submissions, :title
  end
end
