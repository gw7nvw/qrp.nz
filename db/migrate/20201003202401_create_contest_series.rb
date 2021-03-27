class CreateContestSeries < ActiveRecord::Migration
  def change
    create_table :contest_series do |t|
      t.string :name
      t.text :description
      t.date :start_date
      t.date :end_date

      t.boolean :include_qrp
      t.boolean :include_portable
      t.boolean :include_qth
      t.boolean :include_rst
      t.boolean :include_index
      t.boolean :include_freq
      t.boolean :members_only

      t.boolean :is_active
      t.integer :createdBy_id

      t.timestamps
    end
  end
end
