class AddPointsToLogEntry < ActiveRecord::Migration
  def change
   add_column :contest_log_entries, :calc_points, :integer
  end
end
