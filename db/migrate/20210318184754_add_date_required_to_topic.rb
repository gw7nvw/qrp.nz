class AddDateRequiredToTopic < ActiveRecord::Migration
  def change
     add_column :topics, :date_required, :boolean
  end
end
