class CreateNotifies < ActiveRecord::Migration[6.1]
  def change
    create_table :notifies do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.bigint :profile_origin_id
      t.text :message
      t.jsonb :dados
      t.boolean :lido

      t.timestamps
    end
  end
end
