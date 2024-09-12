class RemoveStylesInApps < ActiveRecord::Migration[7.0]
  def change
    remove_column :apps, :styles
  end
end
