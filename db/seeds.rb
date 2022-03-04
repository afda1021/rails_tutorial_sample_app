# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 1人のユーザと、それらしい名前とメアドの99人のユーザーを作成 (リスト10.43)
User.create!(name:  "Example User", # create!：ユーザーが無効な場合にfalseを返すのではなく例外を発生
  email: "example@railstutorial.org",
  password:              "foobar",
  password_confirmation: "foobar",
  admin: true) # このユーザーが管理者 (リスト10.55)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end

# 最初の6人のユーザーに、それぞれ50個分のマイクロポストを追加 (リスト13.25)
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content) }
end

# リレーションシップ (リスト14.14)
users = User.all
user  = users.first
following = users[2..50] # user1にuser3〜51をフォローさせる
followers = users[3..40] # user4〜41にuser1をフォローさせる
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }