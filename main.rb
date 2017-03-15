require 'pry'
require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require_relative 'database_config'
require_relative 'models/user'
require_relative 'models/category'
require_relative 'models/project'
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
    @current_categories = Category.where(user_id: current_user.id)
    if params[:c]
      @current_category = Category.find(params[:c])
      @current_projects = Project.where(category_id: params[:c].to_i)
    end

    if params[:p]
      @current_project = Project.find(params[:p])
      @current_tasks = Task.where(project_id: params[:p].to_i).where(completed: false)
    end
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
get '/new_task/' do
  erb :new_task
end

#gets the form for creating a new project
get '/new_project/' do
  erb :new_project
end

#gets the form for creating a new category
get '/new_category' do
  erb :new_category
end


#gets the form for editing a task
get '/edit_task/:id' do
  @task = Task.find(params[:id])
  erb :edit_task
end

#gets the form for editing a project
get '/edit_project/:id' do
  @project = Project.find(params[:id])
  erb :edit_project
end


#gets the form for editing a category
get '/edit_category/:id' do
  @category = Category.find(params[:id])
  erb :edit_category
end


# gets the form to generate a to do list
get '/list_form' do
  erb :list_form
end

# shows the page of completed tasks
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
  task.estimated_time = (params[:hours].to_i * 60) + params[:minutes].to_i
  task.user_id = current_user.id
  task.project_id = params[:project]
  task.completed = false
  if task.save
    redirect "/?c=#{task.project.category_id}&p=#{task.project_id}"
  else
    erb :new_task
  end
end


#creates a new project
# redirects to index if successful, stay on page if not
post '/new_project' do
  project = Project.new
  project.name = params[:name]
  project.importance = params[:importance]
  project.urgency = params[:urgency]
  project.category_id = params[:category]
  if project.save
    redirect "/?c=#{project.category_id}"
  else
    erb :new_project
  end
end


#creates a new category
# redirects to index if successful, stay on page if not
post '/new_category' do
  category = Category.new
  category.name = params[:name]
  category.importance = params[:importance]
  category.user_id = current_user.id
  if category.save
    redirect '/'
  else
    erb :new_category
  end
end



#updates task, redirects to index
put '/edit_task/:id' do
  task = Task.find(params[:id])
  estimated_time = (params[:hours].to_i * 60) + params[:minutes].to_i
  task.update(name: params[:name], importance: params[:importance], urgency: params[:urgency], estimated_time: estimated_time)
  task.save
  redirect "/?c=#{task.project.category_id}&p=#{task.project_id}"
end



#updates project, redirects to index
put '/edit_project/:id' do
  project = Project.find(params[:id])
  project.update(name: params[:name], importance: params[:importance], urgency: params[:urgency])
  project.save
  redirect "/?c=#{project.category_id}"
end


#updates category, redirects to index
put '/edit_category/:id' do
  category = Category.find(params[:id])
  category.update(name: params[:name], importance: params[:importance])
  category.save
  redirect '/'
end




#deletes task, redirects to index
delete '/delete_task/:id' do
  task = Task.find(params[:id])
  project = task.project
  task.destroy
  redirect "/?c=#{project.category_id}&p=#{project.id}"
end


#deletes project, and all the tasks of the project, redirects to index
delete '/delete_project/:id' do
  project = Project.find(params[:id])
  category = project.category
  project.destroy
  redirect "/?c=#{category.id}"
end


#deletes category, and all the projects and tasks of the category, redirects to index
delete '/delete_category/:id' do
  category = Category.find(params[:id])
  category.destroy
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
