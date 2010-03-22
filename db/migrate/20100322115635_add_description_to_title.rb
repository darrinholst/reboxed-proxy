class AddDescriptionToTitle < ActiveRecord::Migration
  def self.up
    add_column :titles, :description, :text
  end

  def self.down
    remove_column :titles, :description
  end
end
