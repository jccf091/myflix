class PaymentsController < ApplicationController

  def show
    binding.pry
    @payments = current_user.payments
  end

end
