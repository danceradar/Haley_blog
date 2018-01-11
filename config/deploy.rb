require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'  
require 'mina/puma'

set :domain, 'haleyme.com'
set :deploy_to, '/www/Haley_blog'
set :repository, ''
set :branch, 'master'

set :shared_paths, ['config/database.yml','config/local_env.yml','config/secrets.yml', 'log'] 
set :stage, 'production'


task :environment do
        #'rvm:use[ruby-2.0.0-p353@rails]'
  invoke :'rbenv:global[2.4.3]'
end


task :setup => :environment do
  queue! %[mkdir -p "/www/Haley_blog/shared/log"]
  queue! %[chmod g+rx,u+rwx "/www/Haley_blog/shared/log"]

  queue! %[mkdir -p "/www/Haley_blog/shared/config"]
  queue! %[chmod g+rx,u+rwx "/www/Haley_blog/shared/config"]

  queue! %[mkdir -p "/www/Haley_blog/shared/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "/www/Haley_blog/shared/tmp"]
  queue! %[chmod g+rx,u+rwx "/www/Haley_blog/shared/tmp/pids"]

  queue! %[mkdir -p "/www/Haley_blog/shared/tmp/sockets"]
  queue! %[chmod g+rx,u+rwx "/www/Haley_blog/shared/tmp/sockets"]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rake:db:migrate' # 如果是mongoid的话，可以注释掉
    invoke :'rails:assets_precompile'
    

    to :launch do
      queue "touch  /www/Haley_blog/tmp/restart.txt"
    end
  end
end
