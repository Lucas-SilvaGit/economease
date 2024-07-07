# frozen_string_literal: true

class Goal < ApplicationRecord
  include DefaultUuid

  belongs_to :user

  validates :name, presence: true
  validates :target_amount, numericality: { greater_than: 0 }, presence: true
end
