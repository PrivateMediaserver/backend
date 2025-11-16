class CreatePasskeys < ActiveRecord::Migration[8.1]
  def change
    create_table :passkeys, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :credential_id, null: false
      t.binary :public_key, null: false
      t.bigint :sign_count, null: false, default: 0

      t.timestamps
    end

    add_index :passkeys, :user_id, unique: true, name: "index_passkeys_on_user_id_unique"
    add_index :passkeys, :credential_id, unique: true
  end
end
