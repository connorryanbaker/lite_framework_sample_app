require_relative '../../controllers/controller_base'
require_relative '../models/user'
class UsersController < ControllerBase
  def new
    render('new')
  end 

  def show
    @user = User.where(id: params['id'])
    render('show')
  end

  def index
    @users = User.all
    render('index')
  end

  def create
    name, password = params['username'] || params[:username], params['password'] || params[:password]
    @user = User.new(username: name, password: password)
    @user.save
    session[:key] = @user.reset_session_token!
    redirect_to('/')
  end

  def delete
    @user = User.find(req.path.split('/')[-1].to_i)
    @user.remove
    redirect_to('/')
  end 
end
