class AddLocSpecToPost < ActiveRecord::Migration
  def change
    add_column :posts, :hut, :string
    add_column :posts, :park, :string
    add_column :posts, :island, :string
    add_column :posts, :summit, :string
  end
end
