  class Plan < ApplicationRecord
    belongs_to :tenant

    PLANS = {free: 1, premium: 2}

    def self.options
      PLANS.map { |key, value| [key.to_s.capitalize, value] }
    end
  end
