class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.string :phone, index: true
      t.string :nabp

      t.timestamps null: false
    end
  end
end
