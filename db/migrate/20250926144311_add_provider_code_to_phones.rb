class AddProviderCodeToPhones < ActiveRecord::Migration[6.1]
  def change
    add_column :phones, :provider_code, :string
  end
end
