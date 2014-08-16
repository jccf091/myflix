require 'spec_helper'

feature "User sings in" do

  scenario "with valid email and password" do
    user = Fabricate(:user)
    signin(user)
    expect(page).to have_content user.full_name
  end


  scenario "with valid email and password" do
    user = Fabricate(:user, lock: true)
    signin(user)
    expect(page).not_to have_content user.full_name
    expect(page).to have_content("Your account has been suspended, please contact the customer service.")
  end
end
