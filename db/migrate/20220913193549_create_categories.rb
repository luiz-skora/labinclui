class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :nome
      t.string :identifier
      t.bigint :parent_id

      t.timestamps
    end
  end
end
