class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # comment this out when first creating admin user
  before_filter :login_required
  require_role ["admin"]

  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    #logout_keeping_session!
    @user = User.new(params[:user])

    success = @user && @user.save

    if success && @user.errors.empty?
      
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      #redirect_back_or_default('/')
      redirect_to :action => :new
      flash[:notice] = "User added successfully!"
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin."
      render :action => 'new'
    end
  end

end
