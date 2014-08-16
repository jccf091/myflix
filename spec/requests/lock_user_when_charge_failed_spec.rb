require 'spec_helper'

describe "when charge failed" do
  let(:event_date) {
    {
      "created": 1326853478,
      "livemode": false,
      "id": "evt_00000000000000",
      "type": "charge.failed",
      "object": "event",
      "request": null,
      "data": {
        "object": {
          "id": "ch_00000000000000",
          "object": "charge",
          "created": 1408185669,
          "livemode": false,
          "paid": false,
          "amount": 999,
          "currency": "usd",
          "refunded": false,
          "card": {
            "id": "card_00000000000000",
            "object": "card",
            "last4": "4242",
            "brand": "Visa",
            "funding": "credit",
            "exp_month": 11,
            "exp_year": 2014,
            "fingerprint": "BnWgnMI06u49t6Ml",
            "country": "US",
            "name": null,
            "address_line1": null,
            "address_line2": null,
            "address_city": null,
            "address_state": null,
            "address_zip": null,
            "address_country": null,
            "cvc_check": "pass",
            "address_line1_check": null,
            "address_zip_check": null,
            "customer": "cus_00000000000000"
          },
          "captured": true,
          "refunds": {
            "object": "list",
            "total_count": 0,
            "has_more": false,
            "url": "/v1/charges/ch_14S4cTBy5M37OfcV5o1vy45l/refunds",
            "data": [

            ]
          },
          "balance_transaction": "txn_00000000000000",
          "failure_message": null,
          "failure_code": null,
          "amount_refunded": 0,
          "customer": "cus_00000000000000",
          "invoice": "in_00000000000000",
          "description": null,
          "dispute": null,
          "metadata": {
          },
          "statement_description": null,
          "receipt_email": null
        }
      }
    }
  }

  let!(:user) { Fabricate(:user, customer_token: "cus_4bGES1fshmhqnF") }

  before { post stripe_event_path, event_data }

  it "lock user" do
    expect(user.lock?).to be true
  end

  it "send a email to notify user" do
    expect(ActionMailer::Base.deliveries).not_to be_empty

  end

end
