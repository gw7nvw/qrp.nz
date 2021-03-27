class AddBcValid < ActiveRecord::Migration
  def change
    add_column :contest_log_entries, :backcountry_valid, :boolean

  end
end
