# frozen_string_literal: true

class WorkoutTagPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.for_user(user)
    end
  end
end