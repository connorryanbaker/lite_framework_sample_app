require_relative '../config/router.rb'
require_relative './controllers/public_controller'
require_relative './controllers/users_controller'
require_relative './controllers/sessions_controller'
require_relative './controllers/root_controller'
require_relative './controllers/todos_controller'
Router.new.draw do
  get Regexp.new('^\/$'), RootController, :root
  get Regexp.new('^\/app/public/.*$'), PublicController, :serve
  get Regexp.new('^\/users/new$'), UsersController, :new
  # get Regexp.new('^\/users$'), UsersController, :index
  get Regexp.new('^\/users/(?<id>\d+)$'), UsersController, :show
  post Regexp.new('^\/users$'), UsersController, :create
  delete Regexp.new('^\/users\/\d+$'), UsersController, :destroy
  get Regexp.new('^\/session/new$'), SessionsController, :new
  post Regexp.new('^\/session$'), SessionsController, :create
  delete Regexp.new('^\/session$'), SessionsController, :destroy
  post Regexp.new('^\/users/(?<user_id>\d+)/todos$'), TodosController, :create
  get Regexp.new('^\/todos/(?<id>\d+)/edit'), TodosController, :edit
  put Regexp.new('^\/todos/(?<id>\d+)$'), TodosController, :update
  delete Regexp.new('^\/todos/(?<id>\d+)$'), TodosController, :destroy
end
