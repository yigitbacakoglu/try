class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :url
      t.string :permalink
      t.integer :widget_id
      t.integer :category_id
      t.string :title
      t.text :body
      t.integer :position
      t.text :metatags
      t.timestamps
    end
  end
end
