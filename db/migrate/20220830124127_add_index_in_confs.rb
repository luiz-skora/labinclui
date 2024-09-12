class AddIndexInConfs < ActiveRecord::Migration[7.0]
  def change
	  add_index :confs, [:conf_grupo_id, :nome], unique: true
	  rename_column :confs, :value, :valor
  end
end
