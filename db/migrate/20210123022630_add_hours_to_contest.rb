class AddHoursToContest < ActiveRecord::Migration
  def change
    add_column :contest_series, :score_per_hour, :boolean

  end
end
