require 'rubygems'
require 'bundler'
Bundler.require
require 'cgi'             
require 'helpers.rb'
require 'models/models'

mime_type :ttf, 'font/ttf'
mime_type :woff, 'font/woff'

set :views, File.dirname(__FILE__) + '/views'


#-----------------------------------------------------------------------------
#                         PUBLIC SITE
#-----------------------------------------------------------------------------

get '/' do
  
  @projects = Project.all :limit => 4, :order => [ :ordering.asc ]
  erb :welcome
  
end

#       BLOG
#---------------------------------------

get '/blog' do
  
  @posts = Post.all :limit => 5, :order => [ :created_at.desc ]
  
  @posts.each_with_index do |post, index|
    @posts[index].body = convert_pre_to_code post.body
  end
  
  @tags = Tag.all :order => [ :name.asc]
  @num_pages = Post.count / 5
  erb :posts
  
end

get '/blog/page/:page' do
  
  offset = (params[:page].to_i - 1) * 5
  @posts = Post.all :limit => 5, :order => [ :created_at.desc ], :offset => offset
  
  @posts.each_with_index do |post, index|
    @posts[index].body = convert_pre_to_code post.body
  end
  
  @tags = Tag.all :order => [ :name.asc ]
  @num_pages = Post.count / 5
  
  erb :posts
  
end

get '/blog/new' do
  
  protected!
  @post = Post.new
  @post.body = "Write text here"
  erb :post_edit
  
end

get '/blog/:route/edit' do
  
  protected!
  @post = Post.first :route => params[:route]
  @tags = @post.tags.all
  
  @comma_tags = ""
  
  for tag in @tags
    @comma_tags += tag.name + ","
  end
	
  erb :post_edit
  
end

get '/blog/:route' do
  
  @post = Post.first :route => params[:route]
  @post.body = convert_pre_to_code @post.body
  @tags = Tag.all :order => [ :name.asc ]

   if @post.nil?

       # convert old joomla url to sinatra url
       id_num = params[:route].split("-").first
       new_route = params[:route][id_num.length + 1..-1]

       @post = Post.first :route => new_route

       if @post.nil?
         404 
       else
         redirect "/blog/" + new_route  
       end
   else
     erb :post
   end
  
end

get '/blog/tag/:route' do
  
  tag = Tag.first :route => params[:route]
  @posts = tag.posts.all :order => [ :created_at.desc ]
  @tags = Tag.all :order => [ :name.asc ]
  @num_pages = 0
  
  erb :posts
  
end

post '/blog' do
  
  protected!
  
  if params[:id].nil?
    post = Post.create :title => params[:title], 
                              :body => params[:body],
                              :created_at => Time.new,
                              :route  => params[:route]
  else
    post = Post.get params[:id].to_i
    post.update :title => params[:title], :route => params[:route], :body => params[:body]
    
    # delete all taggings
    taggings = Tagging.all :post => post
    for tagging in taggings
      tagging.destroy
    end
    
  end  
  
  tags = params[:comma_tags].split(",")
  
  for tag in tags
    
    cur_tag = Tag.first(:name => tag)
    
    if cur_tag.nil?
      post.tags.create(:name => tag, :route => tag) #route should be parsed
    else
      Tagging.create :post => post, :tag => cur_tag
    end
    
  end
  
  redirect '/blog/' + post.route
  
end

#       WORK
#---------------------------------------

get '/work' do
  
  @projects = Project.all :published=> 1, :order => [ :ordering.asc ]
  erb :projects
  
end

get '/work/new' do
  
  protected!
  @project = Project.new
  erb :project_edit
  
end

get '/work/:route/edit' do
  
  protected!
  @project = Project.first :route => params[:route]
  erb :project_edit
  
end

get '/work/:route' do
  
  @project = Project.first :route => params[:route]
  
  if @project.nil?
      
      # convert old joomla url to sinatra url
      id_num = params[:route].split("-").first
      new_route = params[:route][id_num.length + 1..-1]
      
      @project = Project.first :route => new_route
      
      if @project.nil?
        404
      else
        redirect "/work/" + new_route  
      end
  else
    erb :project
  end
end

post '/work' do
  
  protected!
  
  if params[:id].nil?
    project = Project.create :title => params[:title], 
                              :body => params[:body],
                              :created_at => Time.new,
                              :img_big  => params[:img_big],
                              :img_small  => params[:img_small],
                              :leftbar  => params[:leftbar],
                              :route  => params[:route]
  else
    project = Project.get params[:id]
    project.update params
  end
  
  redirect '/work/' + project.route
  
end

#       BIO
#---------------------------------------

get '/bio' do
  
  erb :bio
  
end

#       CONTACT
#---------------------------------------

get '/contact' do
  
  erb :contact
  
end

#       404
#---------------------------------------

not_found do
  
  route_error = RouteError.first :route => request.path
  
  if route_error.nil?
    RouteError.create( :route => request.path, :numtimes => 1)
  else
    route_error.numtimes = route_error.numtimes + 1
    route_error.save!
  end
  
  erb :notfound
end



