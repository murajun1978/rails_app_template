application = 'APP_NAME'
app_path = "/var/www/#{application}/current"

worker_processes 4
preload_app true

stderr_path "#{app_path}/log/unicorn.stderr.log"
stdout_path "#{app_path}/log/unicorn.stdout.log"

listen "#{app_path}/tmp/sockets/unicorn.sock"
pid "#{app_path}/tmp/pids/unicorn.pid"

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
  sleep 1
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
