class UsersController < ApplicationController
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
    render 'edit'
  end
end
