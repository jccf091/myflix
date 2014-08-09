def set_current_user(user=nil)
  session[:user_id] = ( user || Fabricate(:user) ).id
end

def set_admin_user(admin=nil)
  session[:user_id] = ( admin || Fabricate(:admin) ).id
end

def current_user
  @current_user ||= User.find(session[:user_id])
end

def signin(a_user=nil)
  user = a_user || Fabricate(:user)
  visit signin_path
  fill_in "Email Address", with: user.email
  fill_in "Password", with: user.password

  click_button "Sign In"
end

def signout
  visit signout_path
end

def click_on_video_on_home_page(video)
  find("a[href='/videos/#{video.token}']").click
end
