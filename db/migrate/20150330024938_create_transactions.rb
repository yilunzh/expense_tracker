class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.datetime :purchase_date
      t.string :category
      t.string :description
      t.float :amount
      t.string :paid_by

      t.timestamps
    end
  end
end
