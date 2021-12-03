class AddIndexToUsersEmail < ActiveRecord::Migration[6.1]
  def change
    add_index :users, :email, unique: true # usersテーブルのemailカラムにインデックスを追加
  end
end
