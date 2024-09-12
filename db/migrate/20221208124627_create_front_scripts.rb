class CreateFrontScripts < ActiveRecord::Migration[7.0]
  def change
    create_table :front_scripts do |t|
      t.belongs_to :app, null: false, foreign_key: true
      t.text :header_scripts
      t.text :footer_scripts

      t.timestamps
    end
  end
end
