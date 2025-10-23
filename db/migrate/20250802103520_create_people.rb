class CreatePeople < ActiveRecord::Migration[8.1]
  def change
    create_table :people, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :name

      t.timestamps
    end

    add_index :people, :name, unique: true
  end
end
