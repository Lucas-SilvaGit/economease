# frozen_string_literal: true

module Categories
  class SearchService
    def initialize(user)
      @user = user
    end

    def call
      Category.by_user_accounts(@user)
    end
  end
end
