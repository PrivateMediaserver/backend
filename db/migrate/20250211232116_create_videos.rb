class CreateVideos < ActiveRecord::Migration[8.0]
  def change
    create_table :videos, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false
      t.integer :status, null: false, default: Video.statuses[:unprocessed]

      t.timestamps
    end
  end
end
