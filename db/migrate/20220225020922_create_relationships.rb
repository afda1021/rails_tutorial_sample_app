class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    # それぞれのカラムにインデックスを追加 (リスト14.1)
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
     # 複合キーインデックス、follower_idとfollowed_idの組み合わせが必ずユニーク(同じユーザーを2回以上フォローできない)
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
