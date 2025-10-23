class CreateScreenshots < ActiveRecord::Migration[8.1]
  def change
    create_table :screenshots, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :video, null: false, foreign_key: true, type: :uuid
      t.boolean :main, null: false, default: false

      t.timestamps
    end
    add_index :screenshots, :video_id, where: "main = true", unique: true, name: "index_screenshots_on_video_id_main_true"
  end
end
