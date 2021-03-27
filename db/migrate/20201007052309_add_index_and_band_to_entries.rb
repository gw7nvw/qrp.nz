class AddIndexAndBandToEntries < ActiveRecord::Migration
  def change
   add_column :contest_log_entries, :band, :string
   add_column :contest_log_entries, :rownum, :integer
  end
end
