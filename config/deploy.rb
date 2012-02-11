set :application, "dailymugshot"
set :repository,  "git@github.com:magz/daily_mugshot.git"

set :user, :magz

set :scm, :git
set :scm_passphrase, "starmane999"
set :branch, "master"
ssh_options[:forward_agent] = true

# set :deploy_via, :remote_cache


set :deploy_to, "/var/www/apps/#{application}"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "67.207.144.45"                          # Your HTTP server, Apache/etc
role :app, "67.207.144.45"                          # This may be the same as your `Web` server
role :db,  "67.207.144.45", :primary => true # This is where Rails migrations will run

default_run_options[:pty] = true  

after "deploy:symlink", "deploy:pipeline_precompile"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

namespace :deploy do  
#    task :start do ; end  
#    task :stop do ; end  
#    task :restart, :roles => :app, :except => { :no_release => true } do  
#      run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"  
#    end  
#   
#    desc "Installs required gems"  
#    task :gems, :roles => :app do  
#      run "cd #{current_path} && sudo rake gems:install RAILS_ENV=development"  
#    end  
#    after "deploy:setup", "deploy:gems"     
#   
#    #before "deploy", "deploy:web:disable"  
#    #after "deploy", "de=ploy:web:enable"  
  task :pipeline_precompile do
    run "cd #{deploy_to}/current ; RAILS_ENV=production bundle exec rake assets:precompile"
  end

end  
