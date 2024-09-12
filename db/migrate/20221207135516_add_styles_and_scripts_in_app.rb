class AddStylesAndScriptsInApp < ActiveRecord::Migration[7.0]
  def change
    add_column :apps, :styles, :text
    add_column :apps, :header_scripts, :text
    add_column :apps, :footer_scripts, :text
  end
end
