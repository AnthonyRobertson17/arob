# frozen_string_literal: true

module Golf
  class PuttingSessionPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope.for_user(user)
      end
    end
  end
end
