# frozen_string_literal: true

class HardWorker
  include Sidekiq::Worker

  def perform()
    p 'Hello World!'
  end
end
