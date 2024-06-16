# frozen_string_literal: true

class Account < ApplicationRecord
  include DefaultUuid

  belongs_to :user

  validates :name, presence: true
  validates :balance, numericality: { greater_than: 0 }, presence: true
end
