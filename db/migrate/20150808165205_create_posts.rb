class CreatePosts < ActiveRecord::Migration
  def change
  create_table :posts do |p|
  
  p.text :post_text
  p.timestamps
  end
  
  create_table :comments do |c|
  c.belongs_to :post
  c.integer :post_id
  c.text :comment_text
  c.timestamps
  end
  add_index :comments, :post_id
  end
end
