class CreateFeedEntryUsers < ActiveRecord::Migration
  def change
    create_table :feed_entry_users do |t|
      t.integer :feed_entry_id
      t.integer :user_id
      t.boolean :is_star
      t.boolean :is_to_read
      t.datetime :last_clicked_on
      t.text :categories
      t.datetime :last_starred_at
      t.string :current_star

      t.timestamps
    end
  end
end
