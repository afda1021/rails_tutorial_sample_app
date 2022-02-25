require "test_helper"
# (リスト13.4)
class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    # @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id) # このコードは慣習的に正しくない
    @micropost = @user.microposts.build(content: "Lorem ipsum") # build：オブジェクトを返すがDBには反映されない (リスト13.12)
  end

  # 正常な状態か
  test "should be valid" do
    assert @micropost.valid?
  end

  # user_idが存在しているか
  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  # (リスト13.7)
  # contentも存在するか
  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  # 140文字以内か
  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  # DB上の最初のマイクロポストが、fixture内のマイクロポスト (most_recent) と同じか (リスト13.14)
  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
