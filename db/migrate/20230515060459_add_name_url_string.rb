class AddNameUrlString < ActiveRecord::Migration[7.0]
  def change
    add_column :repositories, :name, :string
    add_column :repositories, :url, :string
    add_column :repositories, :description, :text
  end
end
