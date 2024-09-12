class RenameTagPostsToPostsTags < ActiveRecord::Migration[7.0]
  def change
    rename_table :tags_posts, :posts_tags
  end
end
