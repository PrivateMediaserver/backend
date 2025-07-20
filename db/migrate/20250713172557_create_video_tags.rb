class CreateVideoTags < ActiveRecord::Migration[8.0]
  def change
    create_table :video_tags, id: :uuid do |t|
      t.references :video, null: false, foreign_key: true, type: :uuid
      t.references :tag, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
