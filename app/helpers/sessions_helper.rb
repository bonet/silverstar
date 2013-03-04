module SessionsHelper
  
  def sign_in(user)
    session[:user_id] = user.id
    #logger.debug "SESSION IS: "  + session.to_s
  end
  
  def signed_in?
    #logger.debug "SIGNED IN?" + session[:user_id].to_s
    session.include? :user_id
  end
  
  def sign_out
    session[:user_id] = nil
  end
end
