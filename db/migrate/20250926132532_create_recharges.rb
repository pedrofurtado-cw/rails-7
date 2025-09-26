class CreateRecharges < ActiveRecord::Migration[6.1]
  def change
    create_table :recharges do |t|
      t.bigint :user_id
      t.bigint :phone_id
      t.decimal :amount

      t.timestamps
    end
  end
end
