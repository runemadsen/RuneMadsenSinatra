require 'rubygems'
require 'mysql'
require 'models/models.rb'
require 'cgi'

my = Mysql.new("localhost", "root", "", "oldrune")

# PORT BLOG POST

# result = my.query("select * from jos_content WHERE catid = '2'")
# 
# result.each_hash do |h| 
#    
#     post = Post.create(
#               :title      =>  h['title'],
#               :body       =>  CGI.escape(h['introtext']),
#               :created_at =>  h['created']
#             )
#   
# end

# PORT WORK PROJECTS

# result = my.query("select * from jos_content WHERE catid = '3'")
# 
# result.each_hash do |h| 
#   
#     attribs = h['attribs'].split("\n")
#     
#     leftbar = "";
#     
#     for att in attribs
#       
#       if att[0..10] == 'image1thumb'
#         img_small = att[12..-1]
#         #puts img_small
#       elsif att[0..5] == 'image1'
#         img_big = att[7..-1]
#         leftbar += '<img src="/images/'
#         leftbar += img_big
#         leftbar += '" />'
#         #puts img_big
#       elsif att[0..5] == 'image2' && att[0..10] != 'image2thumb' && att[7..-1] != "-1"
#         leftbar += '<img src="/images/'
#         leftbar += att[7..-1]
#         leftbar += '" />'
#       elsif att[0..5] == 'image3' && att[0..10] != 'image3thumb' && att[7..-1] != "-1"
#         leftbar += '<img src="/images/'
#         leftbar += att[7..-1]
#         leftbar += '" />'
#       elsif att[0..5] == 'image4' && att[0..10] != 'image4thumb' && att[7..-1] != "-1"
#         leftbar += '<img src="/images/'
#         leftbar += att[7..-1]
#         leftbar += '" />'
#       end
#       
#     end
#   
#     post = Project.create(
#               :title      =>  h['title'],
#               :body       =>  CGI.escape(h['introtext']),
#               :created_at =>  h['created'],
#               :ordering   =>  h['ordering'],
#               :img_big    =>  img_big,
#               :img_small  =>  img_small,
#               :leftbar    =>  CGI.escape(leftbar)
#             )
#   
# end

my.close