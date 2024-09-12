class RemoveHeaderAndFooterScriptsInApps < ActiveRecord::Migration[7.0]
  def change
    remove_column :apps, :header_scripts
    remove_column :apps, :footer_scripts
  end
end
