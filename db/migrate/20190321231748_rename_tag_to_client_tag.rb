class RenameTagToClientTag < ActiveRecord::Migration[5.2]
  def change
    rename_table :tags, :client_tags
  end
end
