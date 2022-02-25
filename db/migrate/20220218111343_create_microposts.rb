# (リスト13.1)
class CreateMicroposts < ActiveRecord::Migration[6.1]
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true

      t.timestamps # created_atとupdated_atカラムが追加
    end
    add_index :microposts, [:user_id, :created_at] # user_idとcreated_atカラムにインデックスを付与(複合キーインデックス) (リスト13.3)
  end
end
