class CreateCategoryPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :category_posts do |t|
      t.bigint :category_id
      t.bigint :post_id

      t.timestamps
    end
  end
end
