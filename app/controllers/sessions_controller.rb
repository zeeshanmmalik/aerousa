# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  # render new.rhtml
  def new
  end

  def create
    logout_keeping_session!
    temp_user = User.find_by_login(params[:login])
    login_log = LoginLog.new(:username => params[:login], :ip => request.remote_ip)
    if temp_user and temp_user.last_failed_attempt and temp_user.last_failed_attempt >= Time.now - 5
       flash[:notice] = "Please wait 5 minutes before trying to login again."
       login_log.status = "Retry not allowed"
       login_log.save
       render :action => 'new' and return
    end
    user = User.authenticate(params[:login], params[:password])    
    if user
      login_log.status = "Successful"
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_back_or_default('/')
      flash[:notice] = "Logged in successfully"
    else
      note_failed_signin
      temp_user.update_attribute('last_failed_attempt', Time.now) if temp_user
      flash[:notice] = "Your login attempt has failed. Please try again after 5 minutes"
      login_log.status = "Failed"
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
    login_log.save
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
