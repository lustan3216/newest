class AddKeywordUrlToWebsite < ActiveRecord::Migration[5.1]
  def change
    add_column :websites, :keyword_url, :string
  end
end
