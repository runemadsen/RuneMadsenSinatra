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
  
  has n, :taggings
  has n, :tags, :through => :taggings

end

class Tag
  
  include DataMapper::Resource
  
  property :id,        Serial  
  property :name,      String 
  
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
  
  def html
    <<-OUTPUT
     		<a href="/work/#{id}"> 
        		<img src="/images/#{img_small}" /> 
        	</a>
      OUTPUT
  end
  
end

# DataMapper.auto_upgrade!
# DataMapper.auto_migrate!