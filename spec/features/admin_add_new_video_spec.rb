require 'spec_helper'

feature "Admin adds new video" do
  scenario "Admin sucessfully added a new video" do
    action = Fabricate(:category, name: "Action")
    admin = Fabricate(:admin)

    signin(admin)
    visit new_admin_video_path

    fill_in "Title", with: "Monk"
    select "Action", from: "Category"
    fill_in "Description", with: "Detective"
    fill_in "Or Image Cover Url", with: "http://www.dvdsreleasedates.com/covers/monk-the-complete-series-dvd-cover-38.jpg"
    fill_in "Or Video File Url", with: "https://diikjwpmj92eg.cloudfront.net/uploads/week6/HW2%20charge%20credit%20card%20with%20custom%20form.mp4"
    click_button "Add Video"

    signout
    signin

    visit video_path(Video.first)
    expect(Video.first.cover_image.url).to eq("/public/uploads/video/cover_image/#{Video.first.id}/monk-the-complete-series-dvd-cover-38.jpg")
    expect(Video.first.video_file.url).to eq("/public/uploads/video/video_file/#{Video.first.id}/HW2_20charge_20credit_20card_20with_20custom_20form.mp4")
  end
end
