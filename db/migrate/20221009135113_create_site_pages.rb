class CreateSitePages < ActiveRecord::Migration[7.0]
  def change
    create_table :site_pages do |t|
      t.belongs_to :app, null: false, foreign_key: true
      t.string :route, null: false, index: { unique: true }
      t.string :titulo
      t.timestamps
    end
  end
end
