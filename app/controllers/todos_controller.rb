require_relative '../../controllers/controller_base'
require_relative '../models/todo'
class TodosController < ControllerBase
  def create
    @todo = Todo.new(title: params['title'],
                       description: params['description'],
                       user_id: params['user_id'])
    if @todo.title.length == 0 || @todo.description.length == 0
      flash['errors'] = ['Whoops! Title / Description cannot be blank']
      @user = User.find(@todo.user_id)
      render('show', 'users_controller')
    elsif
      @todo.save
      redirect_to("/users/#{@todo.user_id}")
    else
      render('show', 'users_controller')
    end
  end

  def edit
    @todo = Todo.where(id: params['id'])
    render('edit')
  end

  def update
    @todo = Todo.where(id: params['id'])
    @todo.title = params['title']
    @todo.description = params['description']
    @todo.save
    redirect_to("/users/#{@todo.user_id}")
  end

  def destroy
    @todo = Todo.where(id: params['id'])
    @todo.remove
    redirect_to("/users/#{@todo.user_id}")
  end
end