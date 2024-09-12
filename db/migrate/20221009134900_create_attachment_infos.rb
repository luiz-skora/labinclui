class CreateAttachmentInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :attachment_infos do |t|
      t.belongs_to :app, null: false, foreign_key: true
      t.bigint :blob_id
      t.boolean :public, default: true
      t.string :visible_to
      t.string :description
      t.string :legenda
      t.string :keywords
      t.string :autor
      t.timestamps
    end
  end
end
