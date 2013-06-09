class AddCols2940ToMyEntries < ActiveRecord::Migration
  def change
    add_column :my_entries, :published_at, :datetime
  end
end
