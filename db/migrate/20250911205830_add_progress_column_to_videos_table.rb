class AddProgressColumnToVideosTable < ActiveRecord::Migration[8.0]
  def change
    add_column :videos, :progress, :float, default: 0, null: false
  end
end
