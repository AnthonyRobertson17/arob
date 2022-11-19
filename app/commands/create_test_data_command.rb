# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/ClassLength
class CreateTestDataCommand < BaseCommand
  def execute
    users
    gym_models
    wishlist_models
  end

  private

  def gym_models
    workout_tags
    exercise_type_tags
    workouts
    exercise_types
    exercises
    exercise_sets
  end

  def wishlist_models
    wishlists
    wishlist_items
    wishlist_item_links
  end

  def seed(klass, find_by:, update: nil)
    instance = klass.find_or_initialize_by(find_by)
    instance.update(update) if update
    instance.save!
    instance
  end

  def users
    @users ||= [dev, dev2]
  end

  def dev
    @dev ||= seed(
      User,
      find_by: { email: "dev@test.test" },
      update: { password: "password12345" },
    )
  end

  def dev2
    @dev2 ||= seed(
      User,
      find_by: { email: "dev2@test.test" },
      update: { password: "password12345" },
    )
  end

  def workout_tags
    @workout_tags ||= [
      seed(
        WorkoutTag,
        find_by: { name: "Legs", user: dev },
      ),
      seed(
        WorkoutTag,
        find_by: { name: "Chest", user: dev },
      ),
      seed(
        WorkoutTag,
        find_by: { name: "Chest for user 2", user: dev2 },
      ),
    ]
  end

  def exercise_type_tags
    @exercise_type_tags ||= [
      seed(
        ExerciseTypeTag,
        find_by: { name: "Biceps", user: dev },
      ),
      seed(
        ExerciseTypeTag,
        find_by: { name: "Triceps", user: dev },
      ),
      seed(
        ExerciseTypeTag,
        find_by: { name: "Chest", user: dev2 },
      ),
      seed(
        ExerciseTypeTag,
        find_by: { name: "Legs", user: dev2 },
      ),
    ]
  end

  def exercise_types
    @exercise_types ||= [
      seed(
        ExerciseType,
        find_by: { name: "Bicep Curl", user: dev },
      ),
      seed(
        ExerciseType,
        find_by: { name: "Tricep Extension", user: dev },
      ),
      seed(
        ExerciseType,
        find_by: { name: "Bench Press", user: dev2 },
      ),
      seed(
        ExerciseType,
        find_by: { name: "Shoulder Press", user: dev2 },
      ),
    ]
  end

  def workouts
    @workouts ||= [
      seed(
        Workout,
        find_by: { name: "Let's GOOOO", user: dev },
        update: { started_at: 2.days.ago },
      ),
      seed(
        Workout,
        find_by: { name: "Leg Day", user: dev },
      ),
      seed(
        Workout,
        find_by: { name: "Chest Day", user: dev },
        update: { started_at: 2.days.ago, completed_at: 2.days.ago + 1.hour },
      ),
      seed(
        Workout,
        find_by: { name: "Silly Day", user: dev },
        update: { started_at: 2.days.ago, completed_at: 2.days.ago + 1.hour },
      ),
    ]
  end

  def exercises
    @exercises ||= [
      seed(
        Exercise,
        find_by: { exercise_type: exercise_types.first, workout: workouts.first },
        update: { note: "Used straps, and failed the last rep" },
      ),
      seed(
        Exercise,
        find_by: { exercise_type: exercise_types.second, workout: workouts.first },
        update: { note: "Used straps, and failed the last rep" },
      ),
    ]
  end

  def exercise_sets
    return @exercise_sets if @exercise_sets

    @exercise_sets = []
    exercises.each do |exercise|
      @exercise_sets += [
        seed(
          ExerciseSet,
          find_by: { exercise:, weight: 12.5, repetitions: 15 },
        ),
        seed(
          ExerciseSet,
          find_by: { exercise:, weight: 25, repetitions: 10 },
        ),
        seed(
          ExerciseSet,
          find_by: { exercise:, weight: 35, repetitions: 10 },
        ),
        seed(
          ExerciseSet,
          find_by: { exercise:, weight: 45, repetitions: 8 },
        ),
      ]
    end

    @exercise_sets
  end

  def wishlists
    @wishlists ||= [
      seed(
        Wishlist,
        find_by: { name: "Christmas", user: dev },
      ),
      seed(
        Wishlist,
        find_by: { name: "Birthday", user: dev },
      ),
      seed(
        Wishlist,
        find_by: { name: "Christmas", user: dev2 },
      ),
      seed(
        Wishlist,
        find_by: { name: "Birthday", user: dev2 },
      ),
    ]
  end

  def wishlist_items
    return @wishlist_items if @wishlist_items

    @wishlist_items = []
    wishlists.each do |wishlist|
      @wishlist_items += [
        seed(
          WishlistItem,
          find_by: { wishlist:, name: "Thing 1" },
          update: { price: 12.34 },
        ),
        seed(
          WishlistItem,
          find_by: { wishlist:, name: "Thing 2" },
          update: { price: 78.00 },
        ),
      ]
    end

    @wishlist_items
  end

  def wishlist_item_links
    return @wishlist_item_links if @wishlist_item_links

    @wishlist_item_links = []
    wishlist_items.each do |wishlist_item|
      @wishlist_item_links += [
        seed(
          Link,
          find_by: { linkable: wishlist_item, url: "https://www.google.com" },
        ),
      ]
    end

    @wishlist_item_links
  end
end
# rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Metrics/ClassLength
