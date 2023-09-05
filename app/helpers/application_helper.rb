# frozen_string_literal: true

module ApplicationHelper
  NAVBAR_PATHS = {
    fitness: [
      "/equipment",
      "/exercise_type_tags",
      "/exercise_types",
      "/fitness",
      "/gyms",
      "/workouts",
      "/workout_types",
      "/workout_tags",
    ],
    wishlists: [
      "/wishlists",
    ],
    nutrition: [
      "/nutrition",
      "/food_groups",
      "/foods",
      "/serving_units",
      "/serving_definitions",
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
