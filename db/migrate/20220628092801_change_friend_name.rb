class ChangeFriendName < ActiveRecord::Migration[7.0]
  def change
    rename_table :friends, :friendship
  end
end
