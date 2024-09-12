class RenameAulaToModuloAulaIdInModuloEvaluation < ActiveRecord::Migration[7.0]
  def change
    rename_column :modulo_evaluations, :aula_id, :modulo_aula_id
  end
end
