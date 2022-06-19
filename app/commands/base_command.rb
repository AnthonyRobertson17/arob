# frozen_string_literal: true

class BaseCommand
  class << self
    def execute(...)
      # Subclass is expected to define the execute instance method
      new(...).execute
    end
  end
end
