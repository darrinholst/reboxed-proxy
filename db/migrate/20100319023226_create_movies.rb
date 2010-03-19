class CreateMovies < ActiveRecord::Migration
  def self.up
    create_table :movies do |t|
      t.string :name
      t.string :sort_name
      t.string :image
      t.date :released

      t.timestamps
    end
  end

  def self.down
    drop_table :movies
  end
end
