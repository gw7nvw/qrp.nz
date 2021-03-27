class AddDurationToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :duration, :integer
  end
end
