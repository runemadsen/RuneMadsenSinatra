require 'rubygems'
require 'sinatra'
require 'models/models'
require 'dm-core'
require 'cgi'

mime_type :ttf, 'font/ttf'
mime_type :woff, 'font/woff'

set :views, File.dirname(__FILE__) + '/views'

get '/' do
  
  @projects = Project.all :limit => 4, :order => [ :ordering.asc ]
  erb :welcome
  
end

get '/blog' do
  
  @posts = Post.all :limit => 5, :order => [ :created_at.desc ]
  erb :posts
  
end

get '/blog/:page' do
  
  offset = (params[:page].to_i - 1) * 5
  
  @posts = Post.all :limit => 5, :order => [ :created_at.desc ], :offset => offset
  erb :posts
  
end

get '/work' do
  
  @projects = Project.all :published=> 1, :order => [ :ordering.asc ]
  erb :projects
  
end

get '/work/:id' do
  
  @project = Project.get params[:id].to_i
  erb :project
  
end

get '/bio' do
  
  erb :bio
  
end

get '/contact' do
  
  erb :contact
  
end



