require 'json'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    if req.cookies['_rails_lite_app']
      @cookie = JSON.parse(req.cookies['_rails_lite_app'])
    else
      @cookie = {}
    end 
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  def store_session(res)
    cookie_str = @cookie.reject {|_,v| v.nil?}.to_json
    res.set_cookie('_rails_lite_app', { path: '/',
                                        value: cookie_str })
  end
end
