class CreatePagemakers < ActiveRecord::Migration[7.0]
  def change
    create_table :pagemakers do |t|
      t.string :component
      t.string :identifier
      t.string :ico
      t.string :description
      t.text :html_base

      t.timestamps
    end
  end
end
