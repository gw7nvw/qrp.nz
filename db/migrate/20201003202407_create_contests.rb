class CreateContests < ActiveRecord::Migration
  def change
    create_table :contests do |t|
      t.string :name
      t.text :description
      t.datetime :start_time
      t.datetime :end_time
      t.integer :contest_series_id

      t.boolean :is_active
      t.integer :createdBy_id


      t.timestamps
    end
  end
end
