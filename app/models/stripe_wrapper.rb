module StripeWrapper

  def self.set_api_key
    Stripe.api_key = ENV["strip_secret_key"]
  end

  class Charge

    attr_reader :response, :status

    def initialize(response, status)
      @response = response
      @status = status
    end

    def self.create(options={})
      StripeWrapper.set_api_key

      begin
        response = Stripe::Charge.create(
          :amount => options[:amount],
          :currency => "usd",
          :card => options[:card],
          :description => options[:description]
        )
        new(response, :success)
      rescue Stripe::CardError => e
        new(e, :error)
      end

    end

    def successful?
      status == :success
    end

    def error_message
      response.json_body[:error][:message]
    end
  end

  class Customer

    attr_reader :response, :status

    def initialize(response, status)
      @response = response
      @status = status
    end

    def self.create(options={})
      StripeWrapper.set_api_key

      begin
        response = Stripe::Customer.create(
          card: options[:card],
          plan: "base",
          email: options[:user].email
        )

        new(response, :success)
      rescue Stripe::CardError => e
        new(e, :error)
      end

    end

    def successful?
      status == :success
    end

    def error_message
      response.json_body[:error][:message]
    end

    def customer_token
      response.id
    end
  end
end
