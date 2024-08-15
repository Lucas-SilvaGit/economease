# frozen_string_literal: true

class Category < ApplicationRecord
  include DefaultUuid

  has_many :transactions, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
