class AddArchivedToArticles < ActiveRecord::Migration[8.0]
  def change
    add_column :articles, :archived, :boolean
  end
end
