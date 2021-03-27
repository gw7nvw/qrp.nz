class AddDurationRequiredToTopic < ActiveRecord::Migration
  def change
     add_column :topics, :duration, :boolean

  end
end
