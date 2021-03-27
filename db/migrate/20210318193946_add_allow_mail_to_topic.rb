class AddAllowMailToTopic < ActiveRecord::Migration
  def change
     add_column :topics, :allow_mail, :boolean
  end
end
