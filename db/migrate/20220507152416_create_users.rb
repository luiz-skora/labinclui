class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :login
      t.string :nome
      t.string :email
      t.date :nascimento
      t.text :terms
      t.boolean :terms_acpetd, default: false
      t.string :token
      t.string :recovery_token
      t.integer :user_level, default: 5
      t.datetime :confirmation_at

      t.timestamps
    end
  end
end
