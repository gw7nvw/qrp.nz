class AddDoNotPublishToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :do_not_publish, :boolean
  end
end
