# frozen_string_literal: true

class FoodPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.for_user(user)
    end
  end
end
