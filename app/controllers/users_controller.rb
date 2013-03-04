class UsersController < ApplicationController
  
  before_filter :session_authenticate, :only => [:edit, :update]
  
  def new
    @user = User.new
    @title = "Sign Up"
    #logger.debug "Log Level is: " + logger.level.to_s
  end
  
  def show
    unless signed_in?
      redirect_to signin_path
    end
    
    @user = User.find(params[:id])
    @title = @user.name
  end
  
  def create
    logger.debug params[:user].to_s
    @user = User.new(params[:user])

    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign Up"
      render 'new'
    end
  end
  
  def edit
    @user = User.find(session[:user_id])
    render 'edit'
  end
  
  def update
    @user = User.find(session[:user_id])

    logger.debug "USER PASSWORD I: "+ @user.password.to_s
    if @user.update_attributes(:name => params[:user][:name], :email => params[:user][:email])
      logger.debug "USER PASSWORD II: "+ @user.password.to_s
      flash[:success] = "Profile Updated"
      redirect_to @user
    else
      render 'edit'
    end
    #logger.debug "USER: " + session[:user].to_s
    
  end
  
  private
    def session_authenticate
      deny_access unless signed_in?
    end
end
