class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers] # index, edit, update, destroyの前に実行　(リスト10.15, 14.25)
  before_action :correct_user,   only: [:edit, :update] # edit, updateの前に実行　(リスト10.25)
  before_action :admin_user,     only: :destroy # (リスト10.59)

  # (リスト10.35)
  def index
    @users = User.paginate(page: params[:page]) # paginate(page: "ページ数")：デフォルトで30人ずつ取得 (リスト10.46) # @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page]) # (リスト13.23)
  end

  def new # new(作成ページ) → create(作成処理)
    @user = User.new
  end

  def create
    @user = User.new(user_params) # params[:user]
    if @user.save
      # log_in @user # ユーザー登録時にログインも済ませる
      # flash[:success] = "Welcome to the Sample App!" # (リスト7.29)
      # redirect_to @user # redirect_to user_url(@user)と等価
      # (リスト 11.23)
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new' #views/userのnewファイルを呼び出す
    end
  end

  def edit # edit(更新ページ) → update(更新処理)
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy # (リスト10.58)
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  # (リスト14.25)
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow' # show_follow.html.erbというビューを明示的に呼び出す
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow' # show_follow.html.erbというビューを明示的に呼び出す
  end

  private # 外部から使えないようにする
    def user_params # マスアサインメントの脆弱性を防止
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation) # ※admin以外を許可する
    end

    # beforeアクション

    # 正しいユーザーかどうか確認 (リスト10.25)
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user) # アクセスされたページのユーザー(@user)がログインユーザー(current_user)と一致しているか (リスト10.28)
    end

    # 管理者かどうか確認 (リスト10.59)
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
