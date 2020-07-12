class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :tag, null: false
      t.text :body, null: false
      t.string :study_time, null: false
      t.string :post_image
      t.string :post_video
      t.references :user, null: false, forign_key: true

      t.timestamps
    end
  end
end
