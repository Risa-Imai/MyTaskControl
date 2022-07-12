class AddOauthColumnToCustomers < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :provider, :string
    add_column :customers, :uid, :string
  end
end
