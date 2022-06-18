# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :recoverable and :omniauthable, :registerable
  devise :database_authenticatable, :rememberable, :validatable

  has_many :workouts, dependent: :destroy
  has_many :workout_categories, dependent: :destroy
  has_many :exercise_categories, dependent: :destroy
end
