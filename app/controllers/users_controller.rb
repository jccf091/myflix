class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit,:update, :destroy]
  before_action :require_signed_in_user, only: [:edit, :update]

  def show
    @reviews = @user.reviews if @user
  end

  def new
    @user = User.new
  end

  def new_with_invite
    invitation = Invitation.find_by_token(params[:token])
    if invitation
      @invitation_token = invitation.token
      @user = User.new(full_name: invitation.recipient_name, email: invitation.recipient_email)
      render :new
    else
      redirect_to invalid_token_path
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      handle_invitation


      token = params[:stripeToken]

      charge = StripeWrapper::Charge.create(
        :amount => 999,
        :currency => "usd",
        :card => token,
        :description => "Forever Memebership Charge for #{@user.email}"
      )
      if charge.successful?
        flash[:sucess] = "Thank you!"
      else
        flash[:warning] = charge.error_message
        @user.destroy
        render :new
      end

      UserMailer.delay.welcome_email(@user)
      flash[:success] = "Welcome!"
      session[:user_id] = @user.id
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "You've updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def following
    @followed_users = current_user.followed_users
  end


  private

    def set_user
      @user = User.find_by(slug: params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :full_name, :password, :password_confirmation)
    end

    def handle_invitation
      if params[:invitation_token]
        invitation = Invitation.find_by_token(params[:invitation_token])
        @user.follow(invitation.inviter)
        invitation.inviter.follow(@user)
        invitation.update_column(:token, nil)
      end
    end

    def handle_payment

      end
end
