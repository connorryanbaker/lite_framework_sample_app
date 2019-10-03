require 'erb'

class ShowExceptions
	attr_reader :app
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
			app.call(env)
    rescue StandardError => e
			render_exception(e)
    end 
  end

  private

  def render_exception(e)
    return ['500', {'Content-type' => 'text/html'}, e.message]
  end
end
