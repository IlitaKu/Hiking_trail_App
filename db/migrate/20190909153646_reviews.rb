class Reviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.text :content
      t.integer :rating
      t.integer :hiking_trail_id
      t.integer :user_id
    end
  end
end
