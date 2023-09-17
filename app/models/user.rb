# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :recoverable and :omniauthable, :registerable
  devise :database_authenticatable, :rememberable, :validatable

  has_many :workouts, dependent: :destroy
  has_many :exercises, through: :workouts
  has_many :exercise_types, dependent: :destroy
  has_many :workout_tags, dependent: :destroy
  has_many :exercise_type_tags, dependent: :destroy
  has_many :wishlists, dependent: :destroy
  has_many :food_groups, dependent: :destroy
  has_many :foods, dependent: :destroy
  has_many :meals, dependent: :destroy
  has_many :portions, dependent: :destroy
  has_many :serving_units, dependent: :destroy
  has_many :serving_definitions, dependent: :destroy
end
