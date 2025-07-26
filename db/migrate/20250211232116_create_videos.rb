class CreateVideos < ActiveRecord::Migration[8.0]
  def change
    create_table :videos, id: :uuid do |t|
      t.string :name, null: false
      t.integer :status, null: false, default: Video.statuses[:unprocessed]

      t.timestamps
    end
  end
end
