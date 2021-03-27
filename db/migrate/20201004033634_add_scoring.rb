class AddScoring < ActiveRecord::Migration
  def change
   add_column :contest_series, :base_points, :integer
   add_column :contest_series, :qrp_points, :integer
   add_column :contest_series, :portable_points, :integer
   add_column :contest_series, :cw_points, :integer
   add_column :contest_series, :dx_points, :integer
  end
end
