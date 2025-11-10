class AddViewedColumnToVideos < ActiveRecord::Migration[8.1]
  def change
    add_column :videos,
               :viewed,
               :virtual,
               type: :boolean,
               as: "(duration > 0) AND (progress > 0) AND ((progress / duration) >= 0.9)",
               stored: true
  end
end
