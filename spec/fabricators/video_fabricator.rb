Fabricator(:video) do
  title { Faker::Lorem.characters(10) }
  description { Faker::Lorem.characters(20) }
  cover_image { Faker::Lorem.word }
  category { Category.create(name: Faker::Name.name) }
  token {}
end
