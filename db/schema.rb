ActiveRecord::Schema[7.1].define(version: 2024_01_01_000001) do
  enable_extension 'plpgsql'

  create_table :users, force: :cascade do |t|
    t.string   :email,           null: false
    t.string   :name,            null: false
    t.string   :password_digest, null: false
    t.integer  :role,            default: 0
    t.integer  :status,          default: 0
    t.datetime :last_login_at
    t.timestamps
    t.index :email, unique: true
  end

  create_table :items, force: :cascade do |t|
    t.references :user,     null: false, foreign_key: true
    t.string   :title,      null: false
    t.text     :description
    t.decimal  :price,      precision: 10, scale: 2
    t.integer  :status,     default: 0
    t.string   :slug
    t.jsonb    :metadata,   default: {}
    t.datetime :published_at
    t.timestamps
    t.index :slug, unique: true
  end

  create_table :notifications, force: :cascade do |t|
    t.references :user, null: false, foreign_key: true
    t.string  :notifiable_type
    t.bigint  :notifiable_id
    t.string  :kind,    null: false
    t.text    :message
    t.boolean :read,    default: false
    t.jsonb   :payload, default: {}
    t.timestamps
  end
end
