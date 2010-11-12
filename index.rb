require 'rubygems'
require 'sinatra'
require 'models/blogpost'
require 'dm-core'
require 'cgi'

set :views, File.dirname(__FILE__) + '/views'

get '/blog' do
  
  @posts = BlogPost.all :limit => 5, :order => [ :created_at.desc ]
  erb :blogposts
  
end

get '/blog/:page' do
  
  offset = (params[:page].to_i - 1) * 5
  
  @posts = BlogPost.all :limit => 5, :order => [ :created_at.desc ], :offset => offset
  erb :blogposts
  
end



