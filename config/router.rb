class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern, @http_method, @controller_class, @action_name = pattern, http_method, controller_class, action_name
  end

  def matches?(req)
    req.path =~ pattern && req.request_method.downcase.to_sym == http_method
  end

  def run(req, res)
    match_data = pattern.match(req.path)
    route_params = {}
    match_data.names.each {|k| route_params[k] = match_data[k]}
    controller_class.new(req,res,req.params.merge(route_params)).invoke_action(action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    instance_eval(&proc)
    self
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) {|p, cc, ac| add_route(p, http_method, cc, ac)}
  end

  def match(req)
    @routes.find {|r| r.matches?(req)}
  end

  def run(req, res)
    route = match(req)
    if route
      route.run(req, res)
    else
      res.status = 404
      res.write '404!'
    end
  end
end
