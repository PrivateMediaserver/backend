class CreateVideoTags < ActiveRecord::Migration[8.1]
  def change
    create_table :video_tags, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :video, null: false, foreign_key: true, type: :uuid
      t.references :tag, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
