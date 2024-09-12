class CreateApps < ActiveRecord::Migration[7.0]
  def change
    create_table :apps do |t|
      t.string :site_title
      t.string :site_url

      t.timestamps
    end
  end
end
