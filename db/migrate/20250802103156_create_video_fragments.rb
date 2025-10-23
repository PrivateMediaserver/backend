class CreateVideoFragments < ActiveRecord::Migration[8.1]
  def change
    create_table :video_fragments, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :video, null: false, foreign_key: true, type: :uuid
      t.integer :sequence_number, null: false
      t.float :duration, null: false

      t.timestamps
    end

    add_index :video_fragments, [ :video_id, :sequence_number ], unique: true
  end
end
