class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|

      t.belongs_to :user, null: false, foreign_key: true
      t.string :identifier
      t.string :tipo, default: 'person'
      t.string :nickname
      t.boolean :active
      t.text :bio
      t.string :site
      t.integer :picture
      t.string :country
      t.string :state
      t.string :city
      t.bigint :parent_id
      t.string :slug
      t.bigint :owner_to

      t.timestamps
    end
  end
end
