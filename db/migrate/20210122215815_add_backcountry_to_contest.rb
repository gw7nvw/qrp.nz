class AddBackcountryToContest < ActiveRecord::Migration
  def change
    add_column :contest_series, :include_backcountry, :boolean

  end
end
