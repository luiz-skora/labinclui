class AddTipoInAds < ActiveRecord::Migration[7.0]
  def change
    add_column :ads, :tipo, :string, default: 'Componente'
  end
end
