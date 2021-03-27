class PostIdInFiles < ActiveRecord::Migration
  def change
    add_column :images, :post_id, :integer
    add_column :uploadedfiles, :post_id, :integer

  end
end
