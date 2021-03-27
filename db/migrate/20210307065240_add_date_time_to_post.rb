class AddDateTimeToPost < ActiveRecord::Migration
  def change
#    remove_column :posts, :referenced_datetime
    add_column :posts, :referenced_date, :datetime
    add_column :posts, :referenced_time, :datetime
  end
end
