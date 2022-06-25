# frozen_string_literal:true

class ExerciseTypeTag < Tag
  has_many :exercise_type_tag_assignments, foreign_key: :tag_id, inverse_of: :tag, dependent: :destroy
  has_many :exercise_types, through: :exercise_type_tag_assignments
end
