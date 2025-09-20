class CreateAuthentications < ActiveRecord::Migration[8.0]
  def change
    create_table :authentications, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.uuid :refresh_uuid, null: false
      t.integer :status, null: false, default: Authentication.statuses[:active]
      t.string :user_agent

      t.timestamps
    end

    add_index :authentications, :refresh_uuid, unique: true
  end
end
