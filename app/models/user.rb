# frozen_string_literal: true

class User < ApplicationRecord
  include DefaultUuid

  has_many :accounts, dependent: :destroy
  has_many :goals, dependent: :destroy
  has_many :categories, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, presence: true

  def total_account_balance
    accounts.sum(:balance)
  end
end
