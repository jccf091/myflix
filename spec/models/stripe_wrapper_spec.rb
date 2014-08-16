require 'spec_helper'


describe StripeWrapper::Charge do
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

  context "with valid card" do
    let(:card_number) {"4242424242424242"}

    it "charges the card successfully!", :vcr do
      charge = StripeWrapper::Charge.create(amount: 300, card: token)
      expect(charge.successful?).to be true
    end
  end

  context "with invalid card" do
    let(:card_number) { "4000000000000002" }

    it "does not charge the card successfully", :vcr do
      charge = StripeWrapper::Charge.create(amount: 300, card: token)
      expect(charge.successful?).to be false
    end

    it "contains error message" do
      charge = StripeWrapper::Charge.create(amount: 300, card: token)
      expect(charge.error_message).to eq("Your card was declined.")
    end
  end
end
