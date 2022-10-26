# frozen_string_literal: true

module ApplicationHelper
  NAVBAR_PATHS = {
    gym: [
      "/gym",
      "/workouts",
      "/workout_types",
      "/exercise_types",
      "/workout_tags",
      "/exercise_type_tags",
    ],
    wishlists: [
      "/wishlists",
    ],
  }.freeze

  def active_class(paths)
    paths = Array(paths)
    return "active" if paths.include?(request.path)

    ""
  end

  def show_navbar?(section)
    paths = NAVBAR_PATHS[section]
    paths&.any? { |p| request.path.include?(p) }
  end

  def nested_dom_id(*args)
    args.map { |arg| arg.respond_to?(:to_key) ? dom_id(arg) : arg }.join("_")
  end
end
