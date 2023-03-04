module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id # sessionメソッドで暗号化済みのユーザーIDが自動生成され、ブラウザ内の一時cookiesを作成
  end

  # ユーザーのセッションを永続的にする (リスト 9.8)
  def remember(user)
    user.remember # ランダムな文字列をハッシュ化した文字列をremember_digestに保存
    cookies.permanent.signed[:user_id] = user.id # cookies[:user_id]に暗号化したuser.idを保存
    cookies.permanent[:remember_token] = user.remember_token # ランダムな文字列をcookies[:remember_token]に保存
  end

  # 渡されたユーザーがログイン済みユーザーであればtrueを返す (リスト10.27)
  def current_user?(user)
    user == current_user
  end

  # 記憶トークン (cookie) に対応するユーザーを返す、現在ログイン中のユーザーを返す (いる場合)
  def current_user
    # if session[:user_id] # ユーザーIDを元通りに取り出す
    #   @current_user ||= User.find_by(id: session[:user_id]) # @current_userが空のときだけfind_byが呼び出される
    # end
    # (リスト 9.9)
    if (user_id = session[:user_id]) # 一時セッションが存在すればDBから取得したuserをcurrent_userに設定
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id]) # 一時セッションが存在しなければ永続セッションのuser_idを使用
      user = User.find_by(id: user_id)
      # 永続セッションのuser_idで取得したDBuserのremember_digestと永続セッションのremember_tokenが一致していれば
      # 一時セッションでログインしcurrent_userを設定？
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # 永続的セッションを破棄する (リスト 9.12)
  def forget(user)
    # DBuserのremember_digest, 永続セッションのuser_id, remember_tokenを全て削除
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user) #(リスト 9.12)
    session.delete(:user_id)
    @current_user = nil
  end

  # 記憶したURL (もしくはデフォルト値) にリダイレクト (リスト10.30)
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく (リスト10.30)
  def store_location
    session[:forwarding_url] = request.original_url if request.get? # Getリクエストで送られたURLを:forwarding_urlキーに格納
  end
end
