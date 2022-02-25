# (リスト13.2)
class Micropost < ApplicationRecord
  belongs_to :user # ユーザーと１対１の関係 (user:references)
  default_scope -> { order(created_at: :desc) } # 作成日の降順に並び替え (リスト13.17)
  mount_uploader :picture, PictureUploader # アップローダー (リスト13.59)
  validates :user_id, presence: true # user_idは空は不可(リスト13.5)
  validates :content, presence: true, length: { maximum: 140 } # contentは1〜140文字(リスト13.8)
  validate  :picture_size # (リスト13.65)

  private

    # アップロードされた画像のサイズをバリデーションする (リスト13.65)
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
