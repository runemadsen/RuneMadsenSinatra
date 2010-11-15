require 'rubygems'
require 'sinatra'
require 'models/models'
require 'dm-core'
require 'cgi'
require 'helpers.rb'

mime_type :ttf, 'font/ttf'
mime_type :woff, 'font/woff'

set :views, File.dirname(__FILE__) + '/views'


# => PUBLIC SITE

get '/' do
  
  @projects = Project.all :limit => 4, :order => [ :ordering.asc ]
  erb :welcome
  
end

get '/blog' do
  
  @posts = Post.all :limit => 5, :order => [ :created_at.desc ]
  erb :posts
  
end

get '/blog/:route' do
  
  @post = Post.first :route => params[:route]

   if @post.blank?

       # convert old joomla url to sinatra url
       id_num = params[:route].split("-").first
       new_route = params[:route][id_num.length + 1..-1]

       @project = Project.first :route => new_route

       if @project.blank?
         404 
       else
         redirect "/blog/" + new_route  
       end
   else
     erb :project
   end
  
end

get '/blog/page/:page' do
  
  offset = (params[:page].to_i - 1) * 5
  
  @posts = Post.all :limit => 5, :order => [ :created_at.desc ], :offset => offset
  erb :posts
  
end

get '/work' do
  
  @projects = Project.all :published=> 1, :order => [ :ordering.asc ]
  erb :projects
  
end

get '/work/:route' do
  
  @project = Project.first :route => params[:route]
  
  if @project.blank?
      
      # convert old joomla url to sinatra url
      id_num = params[:route].split("-").first
      new_route = params[:route][id_num.length + 1..-1]
      
      @project = Project.first :route => new_route
      
      if @project.blank?
        404
      else
        redirect "/work/" + new_route  
      end
  else
    erb :project
  end
end

get '/bio' do
  
  erb :bio
  
end

get '/contact' do
  
  erb :contact
  
end

not_found do
  
  route_error = RouteError.first :route => request.path
  
  if route_error.blank?
    RouteError.create( :route => request.path, :numtimes => 1)
  else
    route_error.numtimes = route_error.numtimes + 1
    route_error.save!
  end
  
  erb :notfound
end

# => ADMIN SITE

get '/work/:id/edit' do
  
  protected!
  @project = Project.get params[:id].to_i
  erb :project_edit
  
end

post '/work' do
  
  protected!
  @project = Project.get params[:id].to_i
  @project.update params
  
  redirect '/work/' + params[:id]
  
end


