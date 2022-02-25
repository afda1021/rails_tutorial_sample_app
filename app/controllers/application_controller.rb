class ApplicationController < ActionController::Base
  include SessionsHelper # 全てのcontrollerでSessionsHelperが利用可能

  private

    # ログイン済みユーザーかどうか確認 (リスト10.15, 13.32)
    def logged_in_user
      unless logged_in?
        store_location # (リスト10.31)
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
