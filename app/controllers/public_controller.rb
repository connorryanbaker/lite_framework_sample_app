require_relative '../../controllers/controller_base'

class PublicController < ControllerBase
  def serve
    file = File.read(Dir.pwd + req.path)
    ext = req.path.match(/\..*$/)[0]
    content_type = get_mime_type(ext)
    render_content(file, content_type)
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
