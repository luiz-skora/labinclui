class CreateFrontStyles < ActiveRecord::Migration[7.0]
  def change
    create_table :front_styles do |t|
      t.belongs_to :app, null: false, foreign_key: true
      t.text :styles

      t.timestamps
    end
  end
end
