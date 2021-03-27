class CreateUploadedfiles < ActiveRecord::Migration
  def change
    create_table :uploadedfiles do |t|
      t.string :title
      t.text :description
      t.string :filename
      t.attachment :image
      t.string :filetype

      t.integer :created_by_id
      t.integer :updated_by_id

      t.timestamps
    end
  end
end
