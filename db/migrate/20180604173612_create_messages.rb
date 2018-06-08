class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.text :body
      t.string :email
      t.string :password_digest, default: nil
      t.string :token
      t.string :url_tokens, array: true, default: []
      t.boolean :tos_accepted, default: false
      t.timestamps
    end
  end
end
