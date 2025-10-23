class CreateVideos < ActiveRecord::Migration[8.1]
  def change
    create_table :videos, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false
      t.jsonb :headers
      t.float :duration, null: false, default: 0
      t.integer :width
      t.integer :height
      t.float :progress, null: false, default: 0
      t.integer :status, null: false, default: Video.statuses[:unprocessed]

      t.timestamps
    end
  end
end
