class CreateContestLogs < ActiveRecord::Migration
  def change
    create_table :contest_logs do |t|
      t.string :callsign
      t.string :fullname
      t.string :location
      t.integer :contest_id
      t.datetime :date
      t.string :power
      t.string :antenna
      t.integer :hut_id
      t.integer :park_id
      t.integer :island_id
      t.boolean :is_qrp
      t.boolean :is_portable

      t.timestamps
    end
  end
end
