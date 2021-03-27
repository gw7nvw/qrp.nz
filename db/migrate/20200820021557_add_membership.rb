class AddMembership < ActiveRecord::Migration
  def change
    add_column :topics, :is_members_only, :boolean

  end
end
