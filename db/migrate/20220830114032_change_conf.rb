class ChangeConf < ActiveRecord::Migration[7.0]
  def change
	  drop_table :confs
  end

end
