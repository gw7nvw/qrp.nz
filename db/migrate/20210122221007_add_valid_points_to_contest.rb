class AddValidPointsToContest < ActiveRecord::Migration
  def change
    add_column :contest_series, :valid_points, :integer
    add_column :contest_series, :include_valid, :boolean

  end
end
