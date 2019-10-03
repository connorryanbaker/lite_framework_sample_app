require_relative '../app/controllers/sessions_controller'
require_relative '../app/controllers/root_controller'
require_relative '../app/models/user'
require 'rack'

describe 'SessionsController' do

  describe '#create' do
    let(:env) { {'rack.input' => ''} }
    let(:req) { Rack::Request.new(env) }
    let(:res) { Rack::Response.new([],200,{}) }
    let(:cr0n) { User.where(username: 'cr0nD0n') }
    context 'with valid credentials' do
      before :each do
        User.new(username: 'cr0nD0n', password: 'cr0nD0n').save
        sc = SessionsController.new(req,res,{'username' => 'cr0nD0n',
                                        'password' => 'cr0nD0n'})
        sc.invoke_action(:create)
      end

      after :each do
        User.where(username: 'cr0nD0n').remove
      end

      it 'sets a cookie in the response' do
        expect(res.headers['Set-Cookie']).to include('_rails_lite_app')
      end

      it 'redirects to /' do
        expect(res.status).to be(302)
        expect(res.location).to eq('/')
      end

      it 'authenticates users, showing them their username once logged in' do
        token = cr0n.session_token
        auth_env = {'HTTP_COOKIE' => "_rails_lite_app=%7B%22key%22%3A%22#{token}%22%7D", 'rack.input' => ''}
        auth_req = Rack::Request.new(auth_env)
        rc = RootController.new(auth_req, res)
        rc.invoke_action(:root)
        expect(res.body.join(" ") =~ /cr0nD0n/).to be_truthy
      end
    end 
    context 'with invalid credentials' do

      before :each do
        User.new(username: 'cr0nD0n', password: 'cr0nD0n').save
      end
      
      after :each do
        User.where(username: 'cr0nD0n').remove
      end

      it 'renders the log in page when bad credentials are submitted' do
        sc = SessionsController.new(req, res, {'username' => 'cr0nd00n', 'password' => ''})
        sc.invoke_action(:create)
        expect(res.status).to be(200)
        expect(res.body.join(" ") =~ /Sign In/).to be_truthy
      end
    end
  end

  describe '#destroy' do
    let(:env) { Rack::MockRequest.env_for('/') }
    let(:req) { Rack::Request.new(env) }
    let(:res) { Rack::Response.new([],200,{}) }
    it 'resets the users token and sets key in the cookie to nil' do
      env['rack.request.cookie_hash'] = {"_rails_lite_app":"key=123abc"}
      sc = SessionsController.new(req, res)
      app_cookie = nil
      if res.headers['Set-Cookie']
				app_cookie = res.headers['Set-Cookie'].split('=')[1]
      end
      expect(app_cookie =~ /key/).to be(nil)
    end 
  end
end
