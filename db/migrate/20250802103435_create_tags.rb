class CreateTags < ActiveRecord::Migration[8.0]
  def change
    create_table :tags, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false

      t.timestamps
    end

    add_index :tags, [ :user_id, :name ], unique: true
  end
end
