if ENV['RAILS_ENV'] == 'production'
  app_root = '/www/Haley_blog/shared'
  pidfile "/www/Haley_blog/shared/tmp/pids/puma.pid"
  state_path "/www/Haley_blog/shared/tmp/pids/puma.state"
  bind "unix:///www/Haley_blog/shared/tmp/sockets/puma.sock"
  activate_control_app "unix:///www/Haley_blog/shared/tmp/sockets/pumactl.sock"
#  daemonize true
  workers 2
  threads 8, 16
  preload_app!

  stdout_redirect "/www/Haley_blog/shared/log/puma_access.log", "/www/Haley_blog/shared/log/puma_error.log", true

  on_worker_boot do
    ActiveSupport.on_load(:active_record) do
      ActiveRecord::Base.establish_connection
    end
  end

  before_fork do
    ActiveRecord::Base.connection_pool.disconnect!
  end
else
  plugin :tmp_restart
end
