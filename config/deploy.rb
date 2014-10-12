lock '3.2.1'

# capistrano
set :application, 'APP_NAME'
set :branck,      'master'
set :repo_url,    'git@github.com:xxxx.git'
set :deploy_to,   '/server/rails/path/to'
set :log_level,   :info
set :keep_releases, 5
set :linked_dirs, %w{bin log tmp/backup tmp/pids tmp/cache tmp/sockets vendor/bundle}

# bundler
set :bundle_jobs, 4

# rbenv
set :rbenv_type, :user
set :rbenv_ruby, '2.1.3'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all

# unicorn
set :unicorn_pid, "#{shared_path}/tmp/pids/unicorn.pid"
set :unicorn_rack_env, 'production'
set :unicorn_options, '-p 5000'

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end
