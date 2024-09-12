class ChangeCodeInAds < ActiveRecord::Migration[7.0]
  def change
    change_column :ads, :code, :text
  end
end
