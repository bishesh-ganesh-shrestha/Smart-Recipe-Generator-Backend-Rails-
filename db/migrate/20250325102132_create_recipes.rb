class CreateRecipes < ActiveRecord::Migration[8.0]
  def change
    create_table :recipes do |t|
      t.string :title, null: false
      t.json :ingredients, null: false, default: []
      t.json :directions, null: false, default: []
      t.string :link
      t.string :source
      t.json :NER, default: []

      t.timestamps
    end

    add_index :recipes, :title
    add_index :recipes, :source
  end
end
