class CreateTitles < ActiveRecord::Migration
  def self.up
    create_table :titles do |t|
      t.string :name
      t.string :sort_name
      t.string :image
      t.date :released
      t.integer :product_type

      t.timestamps
    end
  end

  def self.down
    drop_table :titles
  end
end
