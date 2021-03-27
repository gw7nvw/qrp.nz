class CreateUserTopicLinks < ActiveRecord::Migration
  def change
    create_table :user_topic_links do |t|
      t.integer :user_id
      t.integer :topic_id
      t.boolean :mail
      t.timestamps
    end
  end
end
