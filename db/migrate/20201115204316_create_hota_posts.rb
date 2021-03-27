class CreateHotaPosts < ActiveRecord::Migration
  def change
    create_table :hota_posts do |t|
      t.string :title
      t.string :url

      t.timestamps
    end
  end
end
