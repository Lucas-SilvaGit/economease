# frozen_string_literal: true

class Category < ApplicationRecord
  include DefaultUuid

  belongs_to :user
  has_many :transactions, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :user_id }
end
