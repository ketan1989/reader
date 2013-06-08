class AddColsToAppKeyUsers < ActiveRecord::Migration
  def change
    add_column :app_key_users, :colour, :string
    add_column :app_key_users, :categories, :text
  end
end
