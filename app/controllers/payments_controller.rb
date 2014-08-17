class PaymentsController < ApplicationController
  before_action :require_signed_in_user
  
  def show
    @payments = Payments.find_by(user_id: current_user.id)
  end
end
