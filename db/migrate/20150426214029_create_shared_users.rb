class CreateSharedUsers < ActiveRecord::Migration
  def change
    create_table :shared_users do |t|
      t.integer :user_id
      t.string :shared_email
      t.integer :shared_user_id
      t.string :message

      t.timestamps
    end

    add_index :shared_users, :user_id
    add_index :shared_users, :shared_email
    add_index :shared_users, :shared_user_id
  end
end
