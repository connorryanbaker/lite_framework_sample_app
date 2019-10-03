require_relative '../../controllers/controller_base'

class RootController < ControllerBase
  def root
    render('root')
  end
end