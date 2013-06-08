class CreateAppKeyUsers < ActiveRecord::Migration
  def change
    create_table :app_key_users do |t|
      t.integer :user_id
      t.integer :app_key_id

      t.timestamps
    end
  end
end
