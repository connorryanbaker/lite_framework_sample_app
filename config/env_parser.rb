class EnvParser
  def self.check_form_vars(env)
    if env['rack.input'].is_a?(StringIO) && env['rack.input'].string.start_with?('_method')
      method = env['rack.input']
                .string
                .split('&')[0]
                .split('=')[1]
      env['REQUEST_METHOD'] = method
    end 
    env
  end 
end
