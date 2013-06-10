class ChangeColumnDataTypesToTextInEntries < ActiveRecord::Migration
  def change
    change_column :entries, :name, :text
    change_column :entries, :guid, :text
    change_column :entries, :author, :text
  end
end