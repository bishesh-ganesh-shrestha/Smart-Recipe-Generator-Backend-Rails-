class CreatePantries < ActiveRecord::Migration[8.0]
  def change
    create_table :pantries do |t|
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
