class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.text :body, null: false
      t.float :hour, null: false
      t.float :minutes, null: false
      t.string :image_id
      t.string :post_video
      t.references :user, null: false, forign_key: true

      t.timestamps
    end
  end
end
