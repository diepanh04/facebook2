class CreateFriendRequest < ActiveRecord::Migration[7.0]
  def change
    create_table :friend_requests do |t|
      t.integer :user_id
      t.integer :friendship_id

      t.timestamps
    end
  end
end
