class CorrectNameOfDuartionRequired < ActiveRecord::Migration
  def change
    rename_column :topics, :duration, :duration_required 
  end
end
