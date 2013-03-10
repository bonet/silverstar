class UsersController < ApplicationController
  
  before_filter :session_authenticate, :only => [:edit, :update]
  
  #new
  def new
    @user = User.new
    @title = "Sign Up"

    #logger.debug "Log Level is: " + logger.level.to_s
  end
  
  #show
  def show
    unless signed_in? #sessions helper
      redirect_to signin_path
    end
    
    @user = User.find(params[:id])
    @title = @user.username
  end
  
  #create
  def create
    @user = User.new(params[:user])

    if @user.save
      sign_in @user   #sessions helper
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign Up"
      render 'new'
    end
  end
  
  #edit
  def edit
    @user = User.find(session[:user_id])
    render 'edit'
  end
  
  #update
  def update
    @user = User.find(session[:user_id])
    #logger.debug "+++ USER PASSWORD I: "+ @user.password.to_s
    param_hash = { :username => params[:user][:username], :email => params[:user][:email] }

    #only update avatar if the avatar file is present
    if params[:user][:avatar].present? 
      param_hash[:avatar] = params[:user][:avatar]
    end
    
    #only update password if password field is present
    if params[:user][:password].present? 
      param_hash[:password] = params[:user][:password]
    end
    
    if @user.update_attributes(param_hash)
      #logger.debug "USER PASSWORD II: "+ @user.password.to_s
      flash[:success] = "Profile Updated"
      redirect_to @user
    else
      render 'edit'
    end
    #logger.debug "USER: " + session[:user].to_s
    
  end
  
  private
    def session_authenticate
      deny_access unless signed_in? #sessions helper functions
    end
end