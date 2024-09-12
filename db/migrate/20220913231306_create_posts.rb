class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :identifier
      t.string :titulo
      t.datetime :published_in
      t.datetime :changed_in
      t.string :status

      t.timestamps

      t.index :identifier, unique: true
    end
  end
end
