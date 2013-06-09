class RenamingTablesToSomethingSensible < ActiveRecord::Migration
  def change
    drop_table :dashboards
    rename_table :app_keys, :feeds
    rename_table :feed_entries, :entries
    rename_table :app_key_users, :my_feeds
    rename_table :feed_entry_users, :my_entries
    rename_column :my_feeds , :app_key_id , :feed_id
    rename_column :entries , :app_key_id , :feed_id
    rename_column :my_entries , :feed_entry_id , :entry_id
    rename_column :my_entries , :app_key_user_id , :my_feed_id
    rename_column :tag_entries , :app_key_id , :feed_id
    rename_column :tag_entries , :app_key_user_id , :my_feed_id
  end
end