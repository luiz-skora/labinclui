class CreateConfsV2 < ActiveRecord::Migration[7.0]
  def change
    create_table :confs do |t|
      t.belongs_to :conf_grupo, null: false, foreign_key: true
      t.string :nome
      t.string :value
      t.boolean :as_attachment, default: false
      t.jsonb :fields
    
      t.timestamps
    end
  end
end
