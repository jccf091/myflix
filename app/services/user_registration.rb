class UserRegistration

  attr_reader :error_message, :user
  def initialize(user)
    @user = user
    @status
  end

  def registrate(stripe_token, invitation_token)
    if @user.valid?
      charge = StripeWrapper::Charge.create(
        :amount => 999,
        :currency => "usd",
        :card => stripe_token,
        :description => "Forever Memebership Charge for #{@user.email}"
      )
      if charge.successful?
        @user.save
        handle_invitation(invitation_token)
        UserMailer.delay.welcome_email(@user)
        @status = :success
        self
      else
        @status = :failed
        @error_message = charge.error_message
        self
      end
    else
      @status = :failed
      @error_message = "Invalid user information. Please check the errors below."
      self
    end
  end

  def successful?
    @status == :success
  end

  private

  def handle_invitation(invitation_token)
    if invitation_token
      invitation = Invitation.find_by(token: invitation_token)
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end
  end

end
