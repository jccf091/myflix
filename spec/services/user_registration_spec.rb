require 'spec_helper'

describe UserRegistration do
  describe "#sign_up" do
    let(:current_user) { Fabricate(:user)}

    context "valid attributes and valid cards card" do
      let(:charge) { double(:charge, successful?: true ) }
      before do
        StripeWrapper::Charge.stub(:create).and_return(charge)
        UserRegistration.new(Fabricate.build(:user)).registrate("stripe_token", nil)
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

      context "with invitation_token" do
        let(:inv) { Fabricate(:invitation, inviter_id: current_user.id) }

        before do
          charge = double(:charge, successful?: true )
          StripeWrapper::Charge.stub(:create).and_return(charge)
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
    end

    context "valid attributes and invalid card" do
      before do
        charge = double(:charge, successful?: false, error_message: "Your card was declined." )
        StripeWrapper::Charge.stub(:create).and_return(charge)
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

    context "invalid attributes" do

      before do
        StripeWrapper::Charge.stub(:create)
        UserRegistration.new(Fabricate.build(:user, email: current_user.email)).registrate("stripe_token", nil)
      end

      after { ActionMailer::Base.deliveries.clear }

      it "dont create a new user record" do
        expect {
          UserRegistration.new(Fabricate.build(:user, email: current_user.email)).registrate("stripe_token", nil)
        }.not_to change(User, :count)
      end

      it "dont send out email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

  end
end
