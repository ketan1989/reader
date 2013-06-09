class RemoveUnnecessaryColumns < ActiveRecord::Migration
  def change
    remove_column :feed_entries, :is_star
    remove_column :feed_entries, :is_to_read
    remove_column :feed_entries, :last_clicked_on
    remove_column :feed_entries, :user_id
    remove_column :feed_entries, :categories
    remove_column :feed_entries, :last_starred_at
    remove_column :feed_entries, :current_star
    remove_column :app_keys, :user_id
    remove_column :app_keys, :categories
    remove_column :app_keys, :colour
    remove_column :app_keys, :sort_id
    remove_column :app_keys, :app
    remove_column :app_keys, :app_api_token
    remove_column :app_keys, :app_username
    remove_column :app_keys, :app_password
    remove_column :app_keys, :last_request_user_id
    remove_column :app_keys, :error_message
    remove_column :app_keys, :app_account_name
    remove_column :app_keys, :dashboard_id
    remove_column :app_keys, :range
    remove_column :app_keys, :genre
    remove_column :app_keys, :is_advertisement    
    add_column :tag_entries, :app_key_user_id, :integer
    remove_column :app_keys, :favicon
  end
end