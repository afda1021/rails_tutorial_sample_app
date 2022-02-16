class User < ApplicationRecord
  before_save { email.downcase! } # オブジェクトが保存される時点でemail属性を強制的に小文字に変換
  validates :name, presence: true, length: { maximum: 50 } # validates(:name, presence: true) # 空白は無効、長さ制限
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i # メアドの形式を指定
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false }
  has_secure_password # セキュアなパスワードを追加
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true # パスワードは6文字以上、空でもいい(更新時) (リスト10.13)

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
