class AddMetadataToTitle < ActiveRecord::Migration
  def self.up
    add_column :titles, :rating, :string
    add_column :titles, :running_time, :string
    add_column :titles, :actors, :string
    add_column :titles, :yahoo_rating, :string
    add_column :titles, :genre, :string
    add_column :titles, :inv, :string
  end

  def self.down
    remove_column :titles, :rating
    remove_column :titles, :running_time
    remove_column :titles, :actors
    remove_column :titles, :yahoo_rating
    remove_column :titles, :genre
    remove_column :titles, :inv
  end
end
