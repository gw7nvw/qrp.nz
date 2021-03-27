class AddValidToCle < ActiveRecord::Migration
  def change
    add_column :contest_log_entries, :is_valid, :boolean
    add_column :contest_log_entries, :validated_against, :integer
  end
end
