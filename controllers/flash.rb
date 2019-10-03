require 'json'

class Flash
  def initialize(req)
    if req.cookies['_rails_lite_app_flash']
      @cookie = JSON.parse(req.cookies['_rails_lite_app_flash'])
      @count = @cookie['count'] ? @cookie['count'] - 1 : 1
    else
      @cookie = {}
      @count = 2
    end
  end

  def [](key)
    @cookie[key.to_s] 
  end

  def []=(key,value)
    @cookie[key] = value
  end

  def store_flash(res)
    @count -= 1
    @cookie['count'] = @count
    flash_str = @cookie.to_json 
    if @count > 0
      res.set_cookie('_rails_lite_app_flash',
                    {
                      path: '/',
                      value: flash_str
                    })
    else
      value = {count: 0}.to_json
      res.set_cookie('_rails_lite_app_flash', { path: '/', value: value})
    end
  end

  def now
    @count = 1
    return self
  end
end
