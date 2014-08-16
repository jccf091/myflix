Fabricator(:user) do
  email { Faker::Internet.email}
  full_name { Faker::Name.name }
  password { "00001111" }
  password_confirmation { "00001111" }
  admin { false }
  lock { false }
  slug {}
end

Fabricator(:admin, from: :user) do
  admin { true }
end
