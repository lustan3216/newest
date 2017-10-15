class RenameWebsitesKeywordAndCurrentNumber < ActiveRecord::Migration[5.1]
  def change
    rename_column :websites, :current_number, :current_episode
    change_column_default :websites, :keyword, from: :integer, to: :string
  end
end
