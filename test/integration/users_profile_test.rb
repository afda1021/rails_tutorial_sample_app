# (13.2.3)
require "test_helper"

class UsersProfileTest < ActionDispatch::IntegrationTest
  # (リスト13.28)
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  # プロフィール画面に表示されるマイクロポストのテスト
  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name # h1タグ内にユーザー名が存在するか
    assert_select 'h1>img.gravatar' # h1タグの内側に、gravatarクラス付きのimgタグがあるか
    assert_match @user.microposts.count.to_s, response.body # response.body(ページの完全なHTML)のどこかにマイクロポストの投稿数が存在するか
    assert_select 'div.pagination', count: 1 # will_paginateが１度のみ表示されているか (13.2.3 演習3)
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end 
  end
end
