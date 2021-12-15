require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  # 無効な新規ユーザーの登録に関するテスト
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do # このブロックの実行前後でuserの数が変わらないか
      post signup_path, params: { user: { name:  "",
        email: "user@invalid",
        password:              "foo",
        password_confirmation: "bar" } }
    end
    assert_template 'users/new' # 'エラー後viewのusers/newに戻ってくるか？
    assert_select 'div#error_explanation'
    assert_select 'form[action="/signup"]' # formに/signupが存在するか
  end

  # 有効な新規ユーザーの登録に関するテスト
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do # 以下実行前後のuser数の差異が1か
      post users_path, params: { user: { name:  "Example User",
        email: "user@example.com",
        password:              "password",
        password_confirmation: "password" } }
    end
    follow_redirect! # POST結果を見て、指定されたリダイレクト先に移動する
    assert_template 'users/show'
    assert_not flash[:success] == nil
  end
end
