class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password]) # authenticateはパスワードをもとに認証、user情報 or falseを返す
      # (リスト 11.32)
      if @user.activated?
        # ユーザーログイン後にユーザー情報のページにリダイレクトする
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user) #(リスト 9.7, 9.23)
        # redirect_to user # user_url(user) → users#show  削除(リスト10.32)
        redirect_back_or @user # (リスト10.32)
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # エラーメッセージを作成する
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in? # (リスト 9.16)
    redirect_to root_url
  end
end
