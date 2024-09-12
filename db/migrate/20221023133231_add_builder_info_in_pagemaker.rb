class AddBuilderInfoInPagemaker < ActiveRecord::Migration[7.0]
  def change
    add_column :pagemakers, :builder_info, :text
  end
end
