class AddBackcountryToContestLogs < ActiveRecord::Migration
  def change
    add_column :contest_logs, :is_backcountry, :boolean
    add_column :contest_log_entries, :is_backcountry, :boolean

  end
end
