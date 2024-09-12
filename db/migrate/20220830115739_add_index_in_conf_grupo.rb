class AddIndexInConfGrupo < ActiveRecord::Migration[7.0]
  def change
	  add_index :conf_grupos, :nome, unique: true
  end
end
