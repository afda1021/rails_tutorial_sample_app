class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params) # params[:user]
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user # redirect_to user_url(@user)と等価
    else
      render 'new' #views/userのnewファイルを呼び出す
    end
  end

  private # 外部から使えないようにする
    def user_params
      params.require(:user).permit(:name, :email, :password,
        :password_confirmation)
    end
end
