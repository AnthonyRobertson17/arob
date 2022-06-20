# frozen_string_literal:true

class WorkoutTagAssignment < ApplicationRecord
  belongs_to :workout
  belongs_to :tag

  validate :tag_is_workout_type
  validate :same_user_owns_tag_and_workout

  private

  def tag_is_workout_type
    return if tag.type == "WorkoutTag"

    errors.add(:tag, "is the wrong type")
  end

  def same_user_owns_tag_and_workout
    return if tag.user == workout.user

    errors.add(:tag, "doesn't share the same user as the workout")
  end
end
