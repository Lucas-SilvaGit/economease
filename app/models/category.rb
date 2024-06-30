# frozen_string_literal: true

class Category < ApplicationRecord
  include DefaultUuid

  validates :name, presence: true
end
