class CreateConfs < ActiveRecord::Migration[6.1]
  def change
    create_table :confs do |t|
      t.string :nome
      t.string :value
      t.boolean :as_attachment
      t.string :grupo
      t.jsonb :topo_field

      t.timestamps
    end
  end
end
