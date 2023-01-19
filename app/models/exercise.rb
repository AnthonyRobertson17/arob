# frozen_string_literal: true

class Exercise < ApplicationRecord
  belongs_to :workout
  belongs_to :exercise_type
  has_many :exercise_sets, dependent: :destroy

  acts_as_list scope: :workout, top_of_list: 0

  delegate :name, to: :exercise_type
end
