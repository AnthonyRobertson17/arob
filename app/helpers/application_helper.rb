# frozen_string_literal: true

module ApplicationHelper
  def active_class(paths)
    paths = Array(paths)
    return "active" if paths.include?(request.path)

    ""
  end
end
