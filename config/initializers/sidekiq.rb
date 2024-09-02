require 'sidekiq'
require 'sidekiq-scheduler'
require 'sidekiq-scheduler/web'

Sidekiq.configure_server do |config|
  config.on(:startup) do
    schedule_file = "config/sidekiq.yml"

    if File.exist?(schedule_file)
      Sidekiq::Scheduler.reload_schedule!
    end
  end

  log_file = File.open(Rails.root.join('log', 'sidekiq.log'), 'a')
  log_file.sync = true
  config.logger = Logger.new(log_file)
end
