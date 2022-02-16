module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id # sessionメソッドで暗号化済みのユーザーIDが自動生成され、ブラウザ内の一時cookiesを作成
  end

  # 渡されたユーザーがログイン済みユーザーであればtrueを返す (リスト10.27)
  def current_user?(user)
    user == current_user
  end

  # 記憶トークン (cookie) に対応するユーザーを返す、現在ログイン中のユーザーを返す (いる場合)
  def current_user
    if session[:user_id] # ユーザーIDを元通りに取り出す
      @current_user ||= User.find_by(id: session[:user_id]) # @current_userが空のときだけfind_byが呼び出される
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # 現在のユーザーをログアウトする
  def log_out
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
