class DefineLidoDefaultFalseInNotifies < ActiveRecord::Migration[6.1]
  def change
	  change_column :notifies, :lido, :boolean,  default: false
  end
end
