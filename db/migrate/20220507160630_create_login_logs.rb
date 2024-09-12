class CreateLoginLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :login_logs do |t|
      t.bigint :user_or_adm
      t.string :status
      t.string :ip
      t.string :visit_token
      t.string :location
      t.string :so
      t.string :browser
      t.string :user_agent
      t.string :device
      t.timestamps
    end
  end
end
