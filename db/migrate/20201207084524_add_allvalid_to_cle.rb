class AddAllvalidToCle < ActiveRecord::Migration
  def change
    add_column :contest_log_entries, :time_valid, :boolean
    add_column :contest_log_entries, :callsign_valid, :boolean
    add_column :contest_log_entries, :qrp_valid, :boolean
    add_column :contest_log_entries, :portable_valid, :boolean
    add_column :contest_log_entries, :dx_valid, :boolean
    add_column :contest_log_entries, :mode_valid, :boolean
    add_column :contest_log_entries, :name_valid, :boolean
    add_column :contest_log_entries, :location_valid, :boolean
    add_column :contest_log_entries, :frequency_valid, :boolean
    add_column :contest_log_entries, :rst_sent_valid, :boolean
    add_column :contest_log_entries, :index_sent_valid, :boolean
    add_column :contest_log_entries, :rst_recd_valid, :boolean
    add_column :contest_log_entries, :index_recd_valid, :boolean
    add_column :contest_log_entries, :band_valid, :boolean

  end
end
