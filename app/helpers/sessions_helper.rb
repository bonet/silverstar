module SessionsHelper
  
  def sign_in(user)
    session[:user_id] = user.id
    #logger.debug "SESSION IS: "  + session.to_s
  end
  
  def signed_in?
    #logger.debug "SIGNED IN?" + session[:user_id].to_s
    session.include? :user_id
  end
  
  def deny_access
    redirect_to signin_path, :notice => "Please Sign In to access this page"
  end
  
  def sign_out
    session[:user_id] = nil
  end
end
