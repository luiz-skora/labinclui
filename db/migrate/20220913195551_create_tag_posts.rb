class CreateTagPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :tag_posts do |t|
      t.bigint :tag_id
      t.bigint :post_id

      t.timestamps

    end
  end
end
