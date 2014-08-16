require 'spec_helper'

describe  "create payment on successful charge" do

    let(:event_data) {
      {
        "id" => "evt_14S3hfBy5M37OfcVchb3FMLh",
        "created" => 1408182147,
        "livemode" => false,
        "type" => "charge.succeeded",
        "data" => {
          "object" => {
            "id" => "ch_14S3hfBy5M37OfcV8IXAnckd",
            "object" => "charge",
            "created" => 1408182147,
            "livemode" => false,
            "paid" => true,
            "amount" => 999,
            "currency" => "usd",
            "refunded" => false,
            "card" => {
              "id" => "card_14S3heBy5M37OfcVGyWKin6b",
              "object" => "card",
              "last4" => "4242",
              "brand" => "Visa",
              "funding" => "credit",
              "exp_month" => 8,
              "exp_year" => 2015,
              "fingerprint" => "BnWgnMI06u49t6Ml",
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
              "customer" => "cus_4bGES1fshmhqnF"
            },
            "captured" => true,
            "refunds" => {
              "object" => "list",
              "total_count" => 0,
              "has_more" => false,
              "url" => "/v1/charges/ch_14S3hfBy5M37OfcV8IXAnckd/refunds",
              "data" => [
              ]
            },
            "balance_transaction" => "txn_14S3hfBy5M37OfcVMDXtzm0u",
            "failure_message" => nil,
            "failure_code" => nil,
            "amount_refunded" => 0,
            "customer" => "cus_4bGES1fshmhqnF",
            "invoice" => "in_14S3hfBy5M37OfcVlsCKhA9v",
            "description" => nil,
            "dispute" => nil,
            "metadata" => {
            },
            "statement_description" => nil,
            "receipt_email" => nil
          }
        },
        "object" => "event",
        "pending_webhooks" => 1,
        "request" => "iar_4bGEnN1pESXy2N"
      }
    }
  let!(:user) { Fabricate(:user, customer_token: "cus_4bGES1fshmhqnF") }

  before { post stripe_event_path, event_data }

  it "create a payment with webhook from stripe for charge succeeded", :vcr do
    expect(Payment.count).to eq(1)
  end

  it "create a payment assoicated with a user", :vcr do
    expect(Payment.first.user).to eq(user)
  end

  it "create a payment with amount", :vcr do
    expect(Payment.first.amount).to eq(999)
  end

  it "createa a payment with reference id", :vcr do
    expect(Payment.first.reference_id).to eq("ch_14S3hfBy5M37OfcV8IXAnckd")
  end

end
