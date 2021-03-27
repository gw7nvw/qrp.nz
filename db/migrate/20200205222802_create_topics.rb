class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :name
      t.text :description
      t.integer :owner_id
      t.boolean :is_public
      t.boolean :is_owners
      t.datetime :last_updated

      t.integer :created_by_id
      t.integer :updated_by_id

      t.timestamps
    end
  end
end
