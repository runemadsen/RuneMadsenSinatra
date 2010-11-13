require 'rubygems'
require 'sinatra'
require 'models/models'
require 'dm-core'
require 'cgi'

set :views, File.dirname(__FILE__) + '/views'

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
  
  @projects = Project.all :order => [ :ordering.asc ]
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



