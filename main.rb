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
    erb :index
  end
end


# loads splash page with website info, button to log in or create an account
get '/splash' do
  erb :splash
end




















#
