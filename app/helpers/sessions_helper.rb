module SessionsHelper
  
  def sign_in(user)
    session[:valid_user] = user.id
    #logger.debug "SESSION IS: "  + session.to_s
  end
  
  def signed_in?
    #logger.debug "SIGNED IN?" + session[:valid_user].to_s
    session.include? :valid_user
  end
  
  def sign_out
    session[:valid_user] = nil
  end
end
