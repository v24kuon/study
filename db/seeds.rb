# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

  100.times do |n|
    User.create!(
      email: "aaa#{n + 1}@test.com",
      name: "aaa太郎#{n + 1}",
      occupation: "中学生",
      password: "123456789",
    )
  end