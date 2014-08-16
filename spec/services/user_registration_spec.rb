require 'spec_helper'

describe UserRegistration do
  describe "#sign_up" do
    let(:current_user) { Fabricate(:user)}

    context "valid attributes and valid cards card", :vcr do
      let(:customer) { double(:customer, successful?: true, customer_token: "abc") }

      before do
        StripeWrapper::Customer.stub(:create).and_return(customer)
        UserRegistration.new(Fabricate.build(:user)).registrate("stripe_token", nil)
      end

      after { ActionMailer::Base.deliveries.clear }


      it "stores a customer token from stripe" do
        expect(User.last.customer_token).to eq("abc")
      end

      it "creates a new user record" do
        expect {
          UserRegistration.new(Fabricate.build(:user)).registrate("stripe_token", nil)
        }.to change(User, :count).by(1)
      end

      it "sends out a email" do
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it "sends to to right user" do
        expect(ActionMailer::Base.deliveries.last.to).to eq([User.last.email])
      end
    end

    context "valid attributes and valid cards cardwith invitation_token" do
      let(:inv) { Fabricate(:invitation, inviter_id: current_user.id) }
      let(:customer) { double(:customer, successful?: true, customer_token: "abc") }

      before do
        StripeWrapper::Customer.stub(:create).and_return(customer)
        UserRegistration.new(Fabricate.build(:user, email: inv.recipient_email)).registrate("stripe_token", inv.token)
      end

      after { ActionMailer::Base.deliveries.clear }

      it "creates a new user record" do
        expect(User.last.email).to eq(inv.recipient_email)
      end

      it "inviter follow recipient" do
        expect(current_user.following?(User.last)).to be true
      end

      it "inviter follow recipient" do
        expect(User.last.following?(current_user)).to be true
      end

      it "expires the token with @use.save" do
        expect(Invitation.first.token).to eq nil
      end
    end

    context "valid user attributes and invalid card", :vcr do
      before do
        customer = double(:customer, successful?: false, error_message: "Your card was declined." )
        StripeWrapper::Customer.stub(:create).and_return(customer)
        UserRegistration.new(Fabricate.build(:user)).registrate("stripe_token", nil)
      end

      it "dont create a new user record" do
        expect {
          UserRegistration.new(Fabricate.build(:user)).registrate("stripe_token", nil)
        }.not_to change(User, :count)
      end

      it "dont send out email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "invalid user attributes", :vcr do

      before do
        UserRegistration.new(Fabricate.build(:user, email: current_user.email)).registrate("stripe_token", nil)
      end

      after { ActionMailer::Base.deliveries.clear }

      it "dont create a new user record" do
        expect {
          UserRegistration.new(Fabricate.build(:user, email: current_user.email)).registrate("stripe_token", nil)
        }.not_to change(User, :count)
      end

      it "doees not charget the card" do
        StripeWrapper::Customer.should_not_receive(:create)
      end

      it "dont send out email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

  end
end
