class AddCurrentNumberToWebsite < ActiveRecord::Migration[5.1]
  def change
    add_column :websites, :current_number, :integer
  end
end
