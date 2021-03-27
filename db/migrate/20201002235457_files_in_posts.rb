class FilesInPosts < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.string :filename
      t.attachment :image
    end
  end
end
