class AddMinReqsToContestSeries < ActiveRecord::Migration
  def change
   add_column :contest_series, :minreqs, :string
  end
end
