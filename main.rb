require 'pry'
require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require_relative 'database_config'
require_relative 'models/user'
require_relative 'models/task'

#gives us the interface for creating sessions
enable :sessions


#methods you can use anywhere, reusable
helpers do
    def current_user
      User.find_by(id: session[:user_id])
    end

    def logged_in? #should return a boolean
      # equivalent to: current_user != nil
      !!current_user #double negation
    end
end

#closes the connections
# after do -> executes after every block
after do
  ActiveRecord::Base.connection.close
end



# main page, list of tasks,
# only loads if user is logged in, otherwise redirects to splash page
get '/' do
  if !logged_in?
    redirect '/splash'
  else
    # where user id = current_user.id and completed is false
    @current_tasks = Task.where(user_id: current_user.id).where(completed: false)
    erb :index
  end
end


# loads splash page with website info, option to log in or create an account
get '/splash' do
  erb :splash
end

# loads the signup page
get '/signup' do
  erb :signup
end

#loads the login page
get '/login' do
  erb :login
end

#gets the form for creating a new task
get '/new_task' do
  erb :new_task
end

#gets the form for editing a task
get '/edit_task/:id' do
  @task = Task.find(params[:id])
  erb :edit_task
end

# gets the form to generate a to do list
get '/list_form' do
  erb :list_form
end

get '/completed_tasks' do
  @completed_tasks = Task.where(user_id: current_user.id).where(completed: true)
  erb :completed_tasks
end

#creates a new task
# redirects to index if successful, stay on page if not
post '/new_task' do
  task = Task.new
  task.name = params[:name]
  task.importance = params[:importance]
  task.urgency = params[:urgency]
  #params.estimated_time = params[:hours] params[:minutes] processed
  task.user_id = current_user.id
  task.completed = false
  if task.save
    redirect '/'
  else
    erb :new_task
  end
end

#updates task, redirects to index
put '/edit_task/:id' do
  task = Task.find(params[:id])
  task.update(name: params[:name], importance: params[:importance], urgency: params[:urgency]) # include time as well!!!!!!!
  task.save
  redirect '/'
end

#deletes task, redirects to index
delete '/delete_task/:id' do
  task = Task.find(params[:id])
  task.destroy
  redirect '/'
end


# dynamically generates to do list
post '/generate_form' do
  all_tasks = Task.where(user_id: current_user.id)
   @todo_list = all_tasks

  erb :generated_list
end

# logs in the user if they are in the database, redirects to index
# otherwise stays on login page
post '/session' do
  user =User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect '/'
  else
    #who are you?
    erb :login
  end
end

#logs out the current user
delete '/session' do
  session[:user_id] = nil
  redirect '/splash'
end

#creates a new user
#logs them in an redirects to index
#stays on signup page if unsuccesful
post '/create_user' do
  user = User.new
  user.email = params[:email]
  user.password = params[:password]

  if user.save
    session[:user_id] = user.id
    redirect '/'
  else
    erb :signup
  end
end














#
