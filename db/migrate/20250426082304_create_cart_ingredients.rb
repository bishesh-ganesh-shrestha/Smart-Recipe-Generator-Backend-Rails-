class CreateCartIngredients < ActiveRecord::Migration[8.0]
  def change
    create_table :cart_ingredients do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true

      t.timestamps
    end
  end
end
