class CreateWebsites < ActiveRecord::Migration[5.1]
  def change
    create_table :websites do |t|
      t.integer :user_id
      t.integer :number
      t.datetime :read_at
      t.datetime :crawled_at
      t.text :url

      t.timestamps
    end

    add_index :websites, :user_id
  end
end
