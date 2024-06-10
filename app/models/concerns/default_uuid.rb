# frozen_string_literal: true

module DefaultUuid
  extend ActiveSupport::Concern

  included do
    before_create :set_uuid_before_create
  end

  def set_uuid_before_create
    self.id ||= SecureRandom.uuid
  end
end
