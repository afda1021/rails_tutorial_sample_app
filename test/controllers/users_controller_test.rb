require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael) # 本人
    @other_user = users(:archer) # 本人以外
  end

  # (リスト10.34)
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  # editアクション(before_action)のテスト (リスト10.20)
  test "should redirect edit when not logged in" do # 非ログインユーザーは弾かれる
    get edit_user_path(@user)
    assert_not flash.empty? # flashにメッセージがあるか
    assert_redirected_to login_url # ログイン画面にリダイレクトされるか
  end

  # updateアクション(before_action)のテスト (リスト10.20)
  test "should redirect update when not logged in" do # 非ログインユーザーは弾かれる
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  # admin属性の変更禁止のテスト (リスト10.56)
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin? # admin?：adminがtrueか？
    patch user_path(@other_user), params: {
                                    user: { password:              'password',
                                            password_confirmation: 'password',
                                            admin: true } }
    assert_not @other_user.reload.admin?
  end

  # editアクションのテスト (リスト10.24)
  test "should redirect edit when logged in as wrong user" do # ログインユーザーでも本人以外は弾かれる
    log_in_as(@other_user) # 本人以外としてログイン
    get edit_user_path(@user)
    assert flash.empty? # flashメッセージが空か
    assert_redirected_to root_url # ルートURLにリダイレクトされるか
  end

  # updateアクションのテスト (リスト10.24)
  test "should redirect update when logged in as wrong user" do # ログインユーザーでも他人は弾かれる
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  # deleteアクションのテスト (リスト10.61)
  test "should redirect destroy when not logged in" do # 非ログインユーザーの場合ログイン画面にリダイレクト
    assert_no_difference 'User.count' do # ユーザー数が変化しないか
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  # deleteアクションのテスト (リスト10.61)
  test "should redirect destroy when logged in as a non-admin" do # ログインユーザーでも管理者でなければ、ホーム画面にリダイレクト
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  # フォロー/フォロワーページの認可をテスト (リスト14.24)
  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end
