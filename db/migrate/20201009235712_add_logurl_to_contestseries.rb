class AddLogurlToContestseries < ActiveRecord::Migration
  def change
   add_column :contest_series, :log_url, :string

  end
end
