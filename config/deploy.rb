set :application, "runemadsen.com"
set :repository,  "git@github.com:runemadsen/RuneMadsenSinatra.git"

set :scm, :git

set :port, 30000

set :deploy_to, "/home/rune/public_html/runemadsen.com/"

role :app, "runemadsen.com"
role :web, "runemadsen.com"
role :db, "runemadsen.com", :primary => true

set :user, "rune"

set :use_sudo, false