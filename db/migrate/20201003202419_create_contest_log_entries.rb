class CreateContestLogEntries < ActiveRecord::Migration
  def change
    create_table :contest_log_entries do |t|
        t.string :time
        t.string :callsign
        t.boolean :is_qrp
        t.boolean :is_portable
        t.boolean :is_dx
        t.string :mode
        t.string :name
        t.string :location
        t.float :frequency
        t.integer :rst_sent
        t.integer :index_sent
        t.integer :rst_recd
        t.integer :index_recd
        t.integer :contest_log_id

      t.timestamps
    end
  end
end
