# frozen_string_literal: true

module ApplicationHelper
  def active_class(paths)
    paths = Array(paths)
    return "active" if paths.include?(request.path)

    ""
  end

  def nested_dom_id(*args)
    args.map { |arg| arg.respond_to?(:to_key) ? dom_id(arg) : arg }.join("_")
  end
end
