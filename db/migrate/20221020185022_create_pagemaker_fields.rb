class CreatePagemakerFields < ActiveRecord::Migration[7.0]
  def change
    create_table :pagemaker_fields do |t|
      t.belongs_to :pagemaker, null: false, foreign_key: true
      t.string :label
      t.string :field_type
      t.string :default_value
      t.jsonb :options

      t.timestamps
    end
  end
end
