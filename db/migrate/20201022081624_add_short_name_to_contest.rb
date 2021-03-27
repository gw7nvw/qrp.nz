class AddShortNameToContest < ActiveRecord::Migration
  def change
    add_column :contests, :shortname, :string
  end
end
