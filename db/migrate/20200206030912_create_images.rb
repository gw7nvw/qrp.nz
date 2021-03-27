class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :title
      t.text :description
      t.string :filename
      t.attachment :image

      t.integer :created_by_id
      t.integer :updated_by_id

      t.timestamps
    end
  end
end
