# frozen_string_literal:true

class ExerciseTypeTagAssignment < ApplicationRecord
  belongs_to :exercise_type
  belongs_to :tag

  validate :tag_is_exercise_type_type
  validate :same_user_owns_tag_and_exercise_type

  private

  def tag_is_exercise_type_type
    return if tag.type == "ExerciseTypeTag"

    errors.add(:tag, "is the wrong type")
  end

  def same_user_owns_tag_and_exercise_type
    return if tag.user == exercise_type.user

    errors.add(:tag, "doesn't share the same user as the exercise type")
  end
end
