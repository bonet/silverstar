class SessionsController < ApplicationController
  def new
    @title = "Sign In"
  end
  
  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
                             
    if user.nil?
      flash.now[:error] = "Invalid email / password combination"
      @title = "Sign In"
      render 'new'
      
    else
      sign_in user #sessions helper
      redirect_to user
    end
  end
  
  def destroy
    sign_out #sessions helper
    redirect_to root_path
  end
end
