class AddPatternToWebsite < ActiveRecord::Migration[5.1]
  def change
    add_column :websites, :pattern, :integer
  end
end
