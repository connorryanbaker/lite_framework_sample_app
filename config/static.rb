class Static
  attr_reader :app
  def initialize(app)
    @app = app
  end

  def call(env)
    path = env["PATH_INFO"]
    status, headers, body = app.call(env)
    if path.start_with?('/public/')
			begin
				body = File.read(Dir.pwd + path)
				ext = /\.\w+$/.match(path)[0]
				headers["Content-Type"] = get_mime_type(ext) 
        status = body.length > 0 && ext ? 200 : status
			rescue
				status = '404'
				body = 'File not found'
			end 
    end
    [status, headers, body]
  end
  
  private
  def get_mime_type(ext)
    lookup = { ".css" => "text/css",
			".gif" => "image/gif",
      ".html" => "text/html",
      ".jpg" => "image/jpeg",
			".jpeg" => "image/jpeg",
			".js" => "text/javascript",
			".json" => "application/json",
      ".txt" => "text/plain" }
    lookup[ext]
	end 
end
