class CreatePictures < ActiveRecord::Migration[8.0]
  def change
    create_table :pictures do |t|
      t.references :imageable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
