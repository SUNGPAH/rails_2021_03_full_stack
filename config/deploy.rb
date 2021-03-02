# config valid for current version and patch releases of Capistrano
lock "~> 3.15.0"

# set :puma_conf, "/home/ubuntu/myapp/shared/config/puma.rb"

set :application, "myapp"
# set :repo_url, "git@example.com:me/my_repo.git"

set :repo_url, 'git@github.com:ringle-admin/test_rails_6.git'
# set :deploy_to, '/home/ubuntu/trackerr'
# set :deploy_to, '/var/www/myapp'
set :deploy_to, "/home/ubuntu/#{fetch :application}" #여기를 바꿔볼까?
# --- # --- # --- #
# --- # --- # --- #

set :pty, true #퓨마 할 때 이걸 한 번 추가해봤다. 
set :use_sudo, true
set :branch, 'master'
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 
'tmp/sockets', 'vendor/bundle', 'public/system')

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, %w{config/master.key}

append :linked_files, "config/master.key"
# for puma.. uncomment this.
# append :linked_files, "config/master.key"
append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
set :passenger_restart_with_touch

# set :puma_restart_command, 'bundle exec puma'
# namespace :puma do
#     desc 'Create Directories for Puma Pids and Socket'
#     task :make_dirs do
#         on roles(:app) do
#         execute "mkdir #{shared_path}/tmp/sockets -p"
#         execute "mkdir #{shared_path}/tmp/pids -p"
#         end
#     end
#     before :start, :make_dirs
# end


  
