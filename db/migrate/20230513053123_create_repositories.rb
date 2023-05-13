class CreateRepositories < ActiveRecord::Migration[7.0]
  def change
    create_table :repositories do |t|

      t.timestamps
    end
  end
end
