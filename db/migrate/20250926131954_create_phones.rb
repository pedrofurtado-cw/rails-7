class CreatePhones < ActiveRecord::Migration[6.1]
  def change
    create_table :phones do |t|
      t.bigint :user_id
      t.string :phone
      t.text :description

      t.timestamps
    end
  end
end
