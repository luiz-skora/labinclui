class CreatePagemakerComponents < ActiveRecord::Migration[7.0]
  def change
    create_table :pagemaker_components do |t|
      t.belongs_to :app, null: false, foreign_key: true
      t.string :pagemaker_identifier
      t.jsonb :fields

      t.timestamps
    end
  end
end
