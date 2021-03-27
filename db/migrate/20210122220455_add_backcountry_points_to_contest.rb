class AddBackcountryPointsToContest < ActiveRecord::Migration
  def change
    add_column :contest_series, :backcountry_points, :integer

  end
end
