class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token # (リスト 9.3, 11.3)
  before_save   :downcase_email
  before_create :create_activation_digest

  has_many :microposts, dependent: :destroy # userとmicropostsは1対多、ユーザーに紐付いたマイクロポストも一緒に削除 (リスト13.11, 13.19)
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy # このuserが能動的関係を持つuserとのRelationship (リスト14.2)
  has_many :passive_relationships, class_name:  "Relationship",
                                  foreign_key: "followed_id",
                                  dependent:   :destroy # このuserが受動的関係を持つuserとのRelationship (リスト14.12)
  has_many :following, through: :active_relationships, source: :followed # following配列はこのuserにフォローされたuserの集合 (リスト14.8)
  # has_many :followeds, through: :active_relationships # 上はこれでもいいが英文法的に上がふさわしい
  has_many :followers, through: :passive_relationships, source: :follower # followers配列はこのuserをフォローしたuserの集合 (リスト14.12)
  # 上の source: :follower は省略可

  before_save { email.downcase! } # オブジェクトが保存される時点でemail属性を強制的に小文字に変換
  validates :name, presence: true, length: { maximum: 50 } # validates(:name, presence: true) # 空白は無効、長さ制限
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i # メアドの形式を指定
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false }
  has_secure_password # セキュアなパスワードを追加
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true # パスワードは6文字以上、空でもいい(更新時) (リスト10.13)

  class << self # 以下はクラスメソッド (リスト 9.5)
    # 渡された文字列のハッシュ値を返す
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # ランダムなトークンを返す (リスト 9.2)
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # 永続セッションのためにユーザーをデータベースに記憶する (リスト 9.3)
  def remember
    self.remember_token = User.new_token # ランダムな文字列
    update_attribute(:remember_digest, User.digest(remember_token)) # ランダムな文字列をハッシュ化した文字列をremember_digestに保存
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す (リスト 9.6)
  def authenticated?(remember_token)
    return false if remember_digest.nil? # そもそもremember_digestが存在しない場合はfalse (リスト 9.19)
    # remember_tokenはcookies[:remember_token]の値
    # remember_tokenは文字列、remember_digestはハッシュ化した文字列
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する (リスト 9.11)
  def forget
    update_attribute(:remember_digest, nil)
  end

  # 試作feedの定義 (リスト13.46)
  # ユーザーのステータスフィードを返す (リスト14.44)
  def feed
    # Micropost.where("user_id = ?", id) # micropostsと本質的に同等、完全な実装は以下 (リスト13.46)
    # Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id) # (リスト14.44)
    # Micropost.where("user_id IN (:following_ids) OR user_id = :user_id",
    #                 following_ids: following_ids, user_id: id) # 上のコードからキーと値のペアを使って修正 (リスト14.46)
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id) # サブクエリを使って処理を効率化 (リスト14.47)
  end

  # (リスト14.10)
  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  private
    # メールアドレスをすべて小文字にする (リスト 11.3)
    def downcase_email
      self.email = email.downcase
    end

    # 有効化トークンとダイジェストを作成および代入する (リスト 11.3)
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
