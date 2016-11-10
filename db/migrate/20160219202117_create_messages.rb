class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string "to"
      t.string "from"
      t.text "message"
      t.boolean "qs_read", :default => false
      t.references :store

      t.timestamps null: false
    end
  end
end
