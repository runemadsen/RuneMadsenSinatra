require 'dm-migrations'
require 'dm-core'

DataMapper.setup(:default, {
    :adapter  => 'mysql',
    :host     => 'localhost',
    :username => 'root' ,
    :password => '',
    :database => 'runemadsen'})

class Post
  
  include DataMapper::Resource
     
  property :id,         Serial    
  property :title,      String    
  property :body,       Text      
  property :created_at, DateTime
  property :route,      String, :length => 255
  
  has n, :taggings
  has n, :tags, :through => :taggings

end

class Tag
  
  include DataMapper::Resource
  
  property :id,       Serial  
  property :name,     String
  property :route,    String, :length => 255
  
  has n, :taggings
  has n, :posts, :through => :taggings

end

class Tagging
  
  include DataMapper::Resource
  
  belongs_to :tag,   :key => true
  belongs_to :post, :key => true
  
end

class Project
  
  include DataMapper::Resource
  
  property :id,           Serial    
  property :title,        String    
  property :body,         Text      
  property :created_at,   DateTime
  property :img_big,      String 
  property :img_small,    String 
  property :leftbar,      Text
  property :published,    Boolean, :default => true

  property :ordering,     Integer, :default => 99
  property :route,        String, :length => 255
  
  def html
    <<-OUTPUT
     		<a href="/work/#{route}"> 
        		<img src="/images/#{img_small}" /> 
        	</a>
      OUTPUT
  end
  
end

class RouteError
  
  include DataMapper::Resource
  
  property :id,           Serial    
  property :route,        String, :length => 255
  property :numtimes,     Integer
  
end

# DataMapper.auto_upgrade!