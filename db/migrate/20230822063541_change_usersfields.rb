class ChangeUsersfields < ActiveRecord::Migration[7.0]
  def change
    add_column    :users, :name,                   :string
    add_column    :users, :password,               :string
    add_column    :users, :password_digest,        :string
    remove_column :users, :encrypted_password,     :string
    remove_column :users, :reset_password_token,   :string
    remove_column :users, :reset_password_sent_at, :datetime
    remove_column :users, :remember_created_at,    :datetime
  end
end
