class AddActDateToPosts < ActiveRecord::Migration
  def change
   add_column :posts, :referenced_datetime, :datetime

  end
end
