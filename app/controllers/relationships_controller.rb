# フォローとフォロー解除 (14.2.4)
class RelationshipsController < ApplicationController
  before_action :logged_in_user # ログイン済みのユーザーか (リスト14.32)

  # (リスト14.33)
  def create
    user = User.find(params[:followed_id])
    current_user.follow(user) # @user
    redirect_to user
    # respond_to do |format| # Ajaxリクエストに対応 (リスト14.36)
    #   format.html { redirect_to @user }
    #   format.js
    # end
  end

  def destroy
    user = Relationship.find(params[:id]).followed
    current_user.unfollow(user) # @user
    redirect_to user
    # respond_to do |format| # Ajaxリクエストに対応 (リスト14.36)
    #   format.html { redirect_to @user }
    #   format.js
    # end
  end
end
