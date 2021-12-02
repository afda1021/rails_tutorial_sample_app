require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "layout links" do
    get root_path
    assert_template 'static_pages/home' #Homeページが正しいビューを描画しているか
    assert_select "a[href=?]", root_path, count: 2 #<a href="/">...</a>のようなHTMLが2つ含まれているか
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path #<a href="/about">...</a>のようなHTMLがあるか
    assert_select "a[href=?]", contact_path
    get contact_path
    assert_select "title", full_title("Contact")
    get signup_path
    assert_equal full_title('Sign up'), 'Sign up | Ruby on Rails Tutorial Sample App'
  end
end
