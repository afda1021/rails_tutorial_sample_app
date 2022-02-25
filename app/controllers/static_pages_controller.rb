class StaticPagesController < ApplicationController
  def home
    if logged_in? # (リスト13.47)
      @micropost  = current_user.microposts.build # current_user：ユーザーがログインしているときだけ使える
      @feed_items = current_user.feed.paginate(page: params[:page]) # feed：models/user.rbで定義、current_userの全マイクロポストを取得？
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
