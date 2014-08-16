Stripe.api_key = ENV['strip_secret_key']

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    user = User.find_by(customer_token: event.data.object.customer)
    Payment.create(user: user,
                  amount: event.data.object.amount,
                  reference_id: event.data.object.id)
  end

  events.subscribe '' do |event|
    user = User.find_by(customer_token: evnet.data.object.customer)
    user.toggle!(:lock)
    ActionMailer.delay.notify_payment_faild(user)
  end
end
