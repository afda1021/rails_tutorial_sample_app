class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) # authenticateはパスワードをもとに認証、user情報 or falseを返す
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      log_in user
      # redirect_to user # user_url(user) → users#show  削除(リスト10.32)
      redirect_back_or user # (リスト10.32)
    else
      # エラーメッセージを作成する
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
