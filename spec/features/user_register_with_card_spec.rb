require 'spec_helper'

feature 'User registrates with credit card' ,js: true, vcr: true do
  background do
    visit register_path
  end
  
  scenario 'with valid user info input and valid credit card' do
    fill_in_valid_user_info
    fill_in_valid_card_info
    click_button 'Sign Up'
    expect(page).to have_content 'Alice'
  end
  scenario 'with valid user info input and invalid credit card' do
    fill_in_valid_user_info
    fill_in_invalid_card_info
    click_button 'Sign Up'
    expect(page).to have_content 'This card number looks invalid'
  end
  scenario 'with valid user info input and declined credit card' do
    fill_in_valid_user_info_2
    fill_in_declined_card_info
    click_button 'Sign Up'
    expect(page).to have_content 'Your card was declined.'
  end
  scenario 'with invalid user info input and valid credit card' do
    fill_in_invalid_user_info
    fill_in_valid_card_info
    click_button 'Sign Up'
    expect(page).to have_content("Invalid user information. Please check the errors below.")
  end
  scenario 'with invalid user info input and invalid credit card' do
    fill_in_invalid_user_info
    fill_in_invalid_card_info
    click_button 'Sign Up'
    expect(page).to have_content("This card number looks invalid")
  end
  scenario 'with invalid user info input and delined credit card' do
    fill_in_invalid_user_info
    fill_in_declined_card_info
    click_button 'Sign Up'
    expect(page).to have_content("Invalid user information. Please check the errors below.")
  end
end

def fill_in_valid_user_info
  fill_in 'Email Address', with: 'alice@gmail.com'
  fill_in 'Password', with: 'password'
  fill_in 'Confirm Password', with: 'password'
  fill_in 'Full Name', with: 'Alice'
end

def fill_in_valid_user_info_2
  fill_in 'Email Address', with: 'alicexxxxxxxxx@gmail.com'
  fill_in 'Password', with: 'password'
  fill_in 'Confirm Password', with: 'password'
  fill_in 'Full Name', with: 'Alice'
end

def fill_in_invalid_user_info
  fill_in 'Email Address', with: 'alice@gmail.com'
  fill_in 'Full Name', with: 'Alice'
end

def fill_in_valid_card_info
  fill_in 'Credit Card Number', with: '4242424242424242'
  fill_in 'Security Code', with: '314'
  select '1 - January', from: 'date_month'
  select '2015', from: 'date_year'
end

def fill_in_invalid_card_info
  fill_in 'Credit Card Number', with: '123'
  fill_in 'Security Code', with: '314'
  select '1 - January', from: 'date_month'
  select '2015', from: 'date_year'
end

def fill_in_declined_card_info
  fill_in 'Credit Card Number', with: '4000000000000002'
  fill_in 'Security Code', with: '314'
  select '1 - January', from: 'date_month'
  select '2015', from: 'date_year'
end
