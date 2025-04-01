# frozen_string_literal: true

module ApplicationHelper
  NAVBAR_LOOKUP = [
    {
      partial: "layouts/fitness_navbar",
      paths: [
        "/equipment",
        "/exercise_type_tags",
        "/exercise_types",
        "/fitness",
        "/gyms",
        "/workouts",
        "/workout_types",
        "/workout_tags",
      ],
    },
    {
      partial: "layouts/wishlists_navbar",
      paths: [
        "/wishlists",
      ],
    },
    {
      partial: "layouts/nutrition_navbar",
      paths: [
        "/nutrition",
        "/food_groups",
        "/foods",
        "/serving_units",
        "/serving_definitions",
        "/meals",
      ],
    },
  ].freeze

  def active_class(paths)
    paths = Array(paths)
    return "active" if paths.include?(request.path)

    ""
  end

  def render_navbar
    section = NAVBAR_LOOKUP.find { |section| section[:paths]&.any? { |p| request.path.include?(p) } }

    render(section[:partial]) if section.present?
  end

  def nested_dom_id(*args)
    args.map { |arg| arg.respond_to?(:to_key) ? dom_id(arg) : arg }.join("_")
  end
end
