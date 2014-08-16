require 'spec_helper'

describe StripeWrapper do

  before { StripeWrapper.set_api_key }

  let(:token) do
    Stripe::Token.create(
      :card => {
      :number => card_number ,
      :exp_month => 8, :exp_year => 2015,
      :cvc => "314"
      },
    ).id
  end

  describe StripeWrapper::Charge do

    describe ".create" do

      context "with valid card" do
        let(:card_number) {"4242424242424242"}

        it "charges the card successfully!", :vcr do
          response = StripeWrapper::Charge.create(amount: 300, card: token)
          expect(response.successful?).to be true
        end
      end

      context "with invalid card" do
        let(:card_number) { "4000000000000002" }

        it "does not charge the card successfully", :vcr do
          response = StripeWrapper::Charge.create(amount: 300, card: token)
          expect(response.successful?).to be false
        end

        it "contains error message" , :vcr do
          response = StripeWrapper::Charge.create(amount: 300, card: token)
          expect(response.error_message).to eq("Your card was declined.")
        end

      end
    end
  end

  describe StripeWrapper::Customer do
    let(:user) { Fabricate(:user) }

    describe ".create" do
      context "with valid card" do
        let(:card_number) { "4242424242424242" }

        it "create a customer with valid card", :vcr do
          response = StripeWrapper::Customer.create(user: user, card: token)
          expect(response.successful?).to be true
        end

        it "return customer token", :vcr do
          response = StripeWrapper::Customer.create(user: user, card: token)
          expect(response.customer_token).to be_present
        end
      end

      context "with invalid card" do
        let(:card_number) { "4000000000000002" }

        it "doest not create a customer with declind card.", :vcr do
          response = StripeWrapper::Customer.create(user: user, card: token)
          expect(response.successful?).to be false
        end


        it "contains error message", :vcr do
          response = StripeWrapper::Charge.create(amount: 300, card: token)
          expect(response.error_message).to eq("Your card was declined.")
        end

      end

    end
  end
end
