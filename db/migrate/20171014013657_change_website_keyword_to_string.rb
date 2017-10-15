class ChangeWebsiteKeywordToString < ActiveRecord::Migration[5.1]

  def self.up
    change_column :websites, :keyword, :string
  end

  def self.down
    change_column :websites, :keyword, :integer
  end
end
