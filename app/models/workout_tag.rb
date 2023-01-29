# frozen_string_literal:true

class WorkoutTag < Tag
  has_many(:workout_tag_assignments, foreign_key: :tag_id, inverse_of: :tag, dependent: :destroy)
  has_many(:workouts, through: :workout_tag_assignments)

  default_scope { order("lower(name)") }
end
