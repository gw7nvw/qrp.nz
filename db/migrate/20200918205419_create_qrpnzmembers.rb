class CreateQrpnzmembers < ActiveRecord::Migration
  def change
    create_table :qrpnzmembers do |t|
      t.integer :user_id
      t.text :comments

      t.timestamps
    end
  end
end
