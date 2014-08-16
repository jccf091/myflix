require 'spec_helper'

describe "when charge failed" do
  let(:event_data) {
    {
      "id" => "evt_14S5UcBy5M37OfcVukP234uy",
      "created" => 1408189026,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_14S5UcBy5M37OfcV3JMqijFy",
          "object" => "charge",
          "created" => 1408189026,
          "livemode" => false,
          "paid" => false,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_14S5UABy5M37OfcVhc3zbTZG",
            "object" => "card",
            "last4" => "0341",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 8,
            "exp_year" => 2019,
            "fingerprint" => "Ja7kW8NQ9ZpRGSLf",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "customer" => "cus_4bHAdABDVkzikg"
          },
          "captured" => false,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_14S5UcBy5M37OfcV3JMqijFy/refunds",
            "data" => []
          },
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_4bHAdABDVkzikg",
          "invoice" => nil,
          "description" => "payment to failed",
          "dispute" => nil,
          "metadata" => {},
          "statement_description" => nil,
          "receipt_email" => nil
        }
      },
      "object" => "event",
      "pending_webhooks" => 2,
      "request" => "iar_4bI4RUd6MQek6y"
    }
  }

  let!(:user) { Fabricate(:user, customer_token: "cus_4bHAdABDVkzikg") }


  after { ActionMailer::Base.deliveries.clear }

  it "lock user", :vcr do
    post stripe_event_path, event_data
    expect(user.reload.lock?).to be true
  end

  it "send a email to notify user", :vcr do
    post stripe_event_path, event_data
    expect(ActionMailer::Base.deliveries).not_to be_empty
  end

end
