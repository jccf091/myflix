
feature "User sees billing" do
  scenario 'admin can see payments' , js: true, vcr: true do
    alice = Fabricate(:user, full_name: 'Alice', email: 'alice@gmail.com', customer_token: 'cus_4HhnlzKhsgFC4P')
    Fabricate(:payment, amount: 999, user: alice, reference_id: 'abc')
    sign_in(alice)
    visit billing_path
    expect(page).to have_content 'Base Subscription'
    expect(page).to have_content '$9.99 per month'
  end
end
