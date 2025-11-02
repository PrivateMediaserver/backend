class AddLastActiveAtColumnToAuthentications < ActiveRecord::Migration[8.1]
  def change
    add_column :authentications, :last_active_at, :datetime, null: false
  end
end
