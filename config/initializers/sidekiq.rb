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
end
