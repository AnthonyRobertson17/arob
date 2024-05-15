# frozen_string_literal: true

class PuttingPracticeSessionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.for_user(user)
    end
  end
end
