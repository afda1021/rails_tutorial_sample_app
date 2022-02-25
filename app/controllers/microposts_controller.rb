class MicropostsController < ApplicationController
  # (リスト13.34)
  before_action :logged_in_user, only: [:create, :destroy] # create, destroyの前に実行
  before_action :correct_user,   only: :destroy # (リスト13.52)

  # (リスト13.36)
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url # request.referrer：一つ前のURLを返す、ない場合(nil)はroot_url # redirect_back(fallback_location: root_url)と一緒
  end

  private
    # (リスト13.36)
    def micropost_params
      params.require(:micropost).permit(:content, :picture) # (リスト13.61)
    end

    # 現在のユーザーが削除対象のマイクロポストを保有しているか (リスト13.52)
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
