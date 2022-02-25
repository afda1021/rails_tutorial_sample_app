require "test_helper"

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  # (リスト13.31)
  def setup
    @micropost = microposts(:orange)
  end

  # 非ログインの場合、マイクロポストを投稿できない
  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do # post〜してもマイクロポストの数が変わらないか
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end

  # 非ログインの場合、マイクロポストを削除できない
  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do # delete〜してもマイクロポストの数が変わらないか
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end

  # 間違ったユーザーによるマイクロポスト削除はできない (リスト13.54)
  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:michael))
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost)
    end
    assert_redirected_to root_url
  end
end
