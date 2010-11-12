require 'rubygems'
require 'mysql'
require 'models/blogpost.rb'
require 'cgi'

# PORT BLOG POST

my = Mysql.new("localhost", "root", "", "oldrune")
result = my.query("select * from jos_content")
my.close

result.each_hash do |h| 
  
  post = BlogPost.create(
    :title      =>  h['title'],
    :body       =>  CGI.escape(h['introtext']),
    :created_at =>  h['created']
  )
  
end