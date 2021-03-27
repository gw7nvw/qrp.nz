class CreateContestLogBaselines < ActiveRecord::Migration
  def change
    create_table :contest_log_baselines do |t|
      t.integer :contest_id
      t.string :callsign
      t.integer :points

      t.timestamps
    end
  end
end
