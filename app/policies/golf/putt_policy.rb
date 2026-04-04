# frozen_string_literal: true

module Golf
  class PuttPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope.joins(:putting_session).where(golf_putting_sessions: { user_id: user.id })
      end
    end
  end
end
