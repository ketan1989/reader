class AddCols394ToFeedEntryUser < ActiveRecord::Migration
  def change
    add_column :feed_entry_users, :app_key_user_id, :integer
  end
end
