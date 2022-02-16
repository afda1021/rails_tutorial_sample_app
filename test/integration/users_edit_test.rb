require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael) # fixtureのデータを参照
  end

  # user情報の編集失敗時のテスト (リスト10.9)
  test "unsuccessful edit" do
    log_in_as(@user) # ログイン (リスト10.17)
    get edit_user_path(@user) # 編集ページにアクセス "/users/:id/edit"
    assert_template 'users/edit' # editビューが描画されるか
    patch user_path(@user), params: { # users#updateに無効なデータを送信 "PATCH /users/:id"
      user: { 
        name:  "",
        email: "foo@invalid",
        password:              "foo",
        password_confirmation: "bar" 
      } 
    }
    assert_template 'users/edit' # editビューが再描画されるか
    assert_select "div", "The form contains 4 errors." # The form〜文が含まれているか (10.1.3演習)
  end

  # user情報の編集成功時のテスト (リスト10.11)
  test "successful edit with friendly forwarding" do # (リスト10.29)
    get edit_user_path(@user)
    log_in_as(@user) # ログイン (リスト10.17)
    assert_redirected_to edit_user_url(@user) # 編集ページにリダイレクトされているか
    # assert_template 'users/edit' # (リスト10.11)　リダイレクトによってedit用のテンプレートが描画されなくなったので削除
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { # users#updateに有効なデータを送信 "PATCH /users/:id"
      user: { 
        name:  name,
        email: email,
        password:              "",
        password_confirmation: "" 
      } 
    }
    assert_not flash.empty? # flashメッセージが空でないか
    assert_redirected_to @user # プロフィールページにリダイレクトされるか
    @user.reload # DBから最新のユーザー情報を読み込み直し
    # DB内のユーザー情報が正しく変更されたか
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end
