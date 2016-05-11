class AddColumnToWords < ActiveRecord::Migration
  def change
    add_column :words, :description, :text
    add_column :words, :url, :text
    add_column :words, :search_word, :text
  end
end
