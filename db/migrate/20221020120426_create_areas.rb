class CreateAreas < ActiveRecord::Migration[7.0]
  def change
    create_table :areas do |t|
      t.belongs_to :app, null: false, foreign_key: true
      t.string :nome
      t.string :identifier
      t.string :device
      t.string :parent_id

      t.timestamps
    end
  end
end
