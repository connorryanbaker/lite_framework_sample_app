require_relative '../../controllers/controller_base'
require_relative '../models/user'

class SessionsController < ControllerBase
  def create
    user = User.authenticate(params)
    if user
			session[:key] = user.reset_session_token!
      redirect_to('/')
    else
      render('new')
    end
	end
  
  def destroy
    current_user.reset_session_token!
    session[:key] = nil
    redirect_to('/')
  end
  
  def new
    render('new')
  end 
end
