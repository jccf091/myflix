# require 'spec_helper'
#
# feature 'user invite friend' do
#
#   scenario 'friend accept',{ js: true, vcr: true } do
#     current_user = Fabricate(:user)
#     signin(current_user)
#
#     invite_friend
#     friend_accepts_invitation
#
#     click_link "People"
#     expect(page).to have_content(current_user.full_name)
#     signout
#
#     signin(current_user)
#     click_link "People"
#     expect(page).to have_content(current_user.full_name)
#     signout
#
#     clear_emails
#   end
#
#   def invite_friend
#     visit new_invitation_path
#     fill_in "Friend's Name", with: "Ben"
#     fill_in "Recipient email", with: "example@example.com"
#     fill_in "Invitation Message", with: "Please join this really cool site!"
#     click_button 'Send Invitation'
#     signout
#   end
#
#   def friend_accepts_invitation
#     open_email("example@example.com")
#     current_email.click_link 'here'
#     fill_in "Password", with: "00000000"
#     fill_in "Confirm Password", with: "00000000"
#     fill_in 'Credit Card Number', with: '4242424242424242'
#     fill_in 'Security Code', with: '314'
#     select '1 - January', from: "date_month"
#     select 2016 , from: 'date_year'
#     click_button "Sign Up"
#   end
# end
