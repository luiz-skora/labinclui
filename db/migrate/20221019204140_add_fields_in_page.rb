class AddFieldsInPage < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :device, :string, default: "Desktop"
    add_column :pages, :parent_id, :bigint
    add_column :pages, :header_area_id, :bigint
    add_column :pages, :footer_area_id, :bigint
  end
end
