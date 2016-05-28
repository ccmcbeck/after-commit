class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.string :title
      t.text :text
      t.integer :number
      t.datetime :test_at

      t.timestamps null: false
    end
  end
end
