class RenameColumnInCursos < ActiveRecord::Migration[7.0]
  def change
    rename_column :cursos, :cooredenador_id, :coordenador_id
  end
end
