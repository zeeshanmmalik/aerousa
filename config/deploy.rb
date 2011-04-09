set :application, "aerousa"
set :repository,  "removed"
set :user, 'aerousa'

default_run_options[:pty] = true

task :staging do

set :deploy_to, "/var/www/apps/#{application}"
set :use_sudo, false
set :deploy_via, :remote_cache
set :deploy_to_env, "production"

role :app, "ipremoved"
role :web, "ipremoved"
role :db,  "ipremoved", :primary => true

end

task :production do

set :deploy_to, "/var/www/apps/#{application}"
set :use_sudo, false
set :deploy_via, :remote_cache
set :deploy_to_env, "production"

role :app, "ipremoved"
role :web, "ipremoved"
role :db,  "ipremoved", :primary => true

end

# =============================================================================
# TASKS
# =============================================================================

desc "Restart the app server"
task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
end

desc "Link in the shared configuration files"
task :after_update_code do
  %w(database.yml).each do |filename|
      run "ln -nfs #{shared_path}/#{filename} #{release_path}/config/#{filename}"
  end
  run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  run "chmod a+x #{release_path}/script/runner"
end

desc "cleanup old releases from server"
task  :after_default, :roles => :app do
  deploy.cleanup
end

deploy.web.task :disable, :roles => :web, :except => { :no_release => true } do
  on_rollback { run "rm #{shared_path}/system/maintenance.html" }
  result = File.read(File.join(File.dirname(__FILE__), "system", "maintenance.rhtml"))
  put result, "#{shared_path}/system/maintenance.html", :mode => 0644
end
