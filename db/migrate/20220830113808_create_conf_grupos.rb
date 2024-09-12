class CreateConfGrupos < ActiveRecord::Migration[7.0]
  def change
    create_table :conf_grupos do |t|
      t.string :nome

      t.timestamps
    end
  end
end
