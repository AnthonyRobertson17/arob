# frozen_string_literal: true

class ExerciseTypePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.for_user(user)
    end
  end
end
