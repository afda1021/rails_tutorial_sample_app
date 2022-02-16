# (リスト10.48)
require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end

  # 管理者ログイン時のページネーションとdeleteリンク表示のテスト (リスト10.62)
  test "index as admin including pagination and delete links" do
    log_in_as(@admin) # 管理者としてログイン
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2 # ページネーションが2つ表示されているか
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user| # 1ページのユーザーを1人ずつ実行
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete' # 自分(管理者)以外のユーザーにdeleteが表示されているか
      end
    end
    assert_difference 'User.count', -1 do # 以下delete実行で、ユーザー数が1減ったか
      delete user_path(@non_admin)
    end
  end

  # 非管理者ログイン時のdeleteリンク非表示のテスト(リスト10.62)
  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end
