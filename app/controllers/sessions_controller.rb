class SessionsController < ApplicationController

  def new
    redirect_to root_path if current_user
  end

  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])
      unless user.lock?
        session[:user_id] = user.id
        flash[:success] = "Welcome back, #{user.full_name}."
        redirect_to videos_path
      else
        flash[:warning] = "Your account has been suspended, please contact the customer service." 
        redirect_to root_path
      end
    else
      flash[:danger] = "wrong email address or password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You've sign out."
    redirect_to root_path
  end

end
