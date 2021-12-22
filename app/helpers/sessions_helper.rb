module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id # sessionメソッドで暗号化済みのユーザーIDが自動生成され、ブラウザ内の一時cookiesを作成
  end

  # 現在ログイン中のユーザーを返す (いる場合)
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
end
