class CreateContribConfigs < ActiveRecord::Migration
  def change
    create_table :contrib_configs do |t|
      t.integer :user_id
      t.float :budgeted_contrib
      t.integer :over_spend

      t.timestamps
    end
  end
end
