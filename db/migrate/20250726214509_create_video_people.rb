class CreateVideoPeople < ActiveRecord::Migration[8.0]
  def change
    create_table :video_people, id: :uuid do |t|
      t.references :video, null: false, foreign_key: true, type: :uuid
      t.references :person, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :video_people, [ :video_id, :person_id ], unique: true
  end
end
