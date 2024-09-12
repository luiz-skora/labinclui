class RenameTagPostsToTagsPosts < ActiveRecord::Migration[7.0]
  def change
    rename_table :tag_posts, :tags_posts
  end
end
