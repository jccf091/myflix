require "faker"
cat = Category.create(name: "fake")
10000.times do |i|
  Video.create(title: "#{Faker::Commerce.product_name}#{i}", description: Faker::Lorem.paragraph, category: cat )
end
