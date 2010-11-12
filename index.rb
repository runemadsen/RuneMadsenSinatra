require 'rubygems'
require 'sinatra'
require 'models/blogpost'
require 'dm-core'
require 'cgi'

set :views, File.dirname(__FILE__) + '/views'

get "/blog" do
  
  @posts = BlogPost.all :limit => 5
  
  erb :blogposts
end