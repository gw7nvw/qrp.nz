class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :description
      t.integer :created_by_id
      t.integer :updated_by_id

      t.timestamps
    end
  end
end
