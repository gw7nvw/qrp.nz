class AddLogTemplateToSeries < ActiveRecord::Migration
  def change
    add_column :contest_series, :xls_log_url, :string
    add_column :contest_series, :odt_log_url, :string

  end
end
