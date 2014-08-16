require 'spec_helper'

feature "Admin sees payment" do
  background do
    ben = Fabricate(:user, full_name: 'Ben', email: 'ben@gmail.com')
    Fabricate(:payment, amount: 999, user: ben, reference_id: 'abc')
  end
  scenario 'admin can see payments' do
    signin(Fabricate(:admin))
    visit admin_payments_path
    expect(page).to have_content '$9.99'
    expect(page).to have_content 'abc'
    expect(page).to have_content 'Ben'
    expect(page).to have_content 'ben@gmail.com'
  end
  scenario 'user cannot see payments' do
    signin(Fabricate(:user))
    visit admin_payments_path
    expect(page).not_to have_content '$9.99'
    expect(page).not_to have_content 'abc'
    expect(page).not_to have_content 'Ben'
    expect(page).not_to have_content 'ben@gmail.com'
    expect(page).to have_content 'You do not have access to that area.'
  end
end
