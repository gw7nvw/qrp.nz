class AddCallsignToPost < ActiveRecord::Migration
  def change
    add_column :posts, :callsign, :string
  end
end
