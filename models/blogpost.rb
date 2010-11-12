require 'dm-migrations'
require 'dm-core'

DataMapper.setup(:default, {
    :adapter  => 'mysql',
    :host     => 'localhost',
    :username => 'root' ,
    :password => '',
    :database => 'runemadsen'})

class BlogPost
  
  #  attr_accessor :hex_value, :width, :height
  include DataMapper::Resource
     
  property :id,         Serial    
  property :title,      String    
  property :body,       Text      
  property :created_at, DateTime

end

#DataMapper.auto_migrate!