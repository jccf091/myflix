class AdminsController < ApplicationController
  before_action :require_signed_in_user, :ensure_admin

  def ensure_admin
    unless current_user.admin?
      flash[:danger] = "You do not have access to that area."
      redirect_to videos_path
    end
  end
end
