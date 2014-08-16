class Admin::PaymentsController < AdminsController

  def index
    @payments = Payment.all
    binding.pry
  end
end
