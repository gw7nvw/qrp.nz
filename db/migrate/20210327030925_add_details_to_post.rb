class AddDetailsToPost < ActiveRecord::Migration
  def change
    add_column :posts, :site, :string
    add_column :posts, :code, :string
    add_column :posts, :mode, :string
    add_column :posts, :freq, :string
    add_column :posts, :is_hut, :boolean
    add_column :posts, :is_park, :boolean
    add_column :posts, :is_island, :boolean
    add_column :posts, :is_summit, :boolean
    add_column :topics, :is_alert, :boolean
    add_column :topics, :is_spot, :boolean
  end
end
