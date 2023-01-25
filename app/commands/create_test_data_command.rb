# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/ClassLength
class CreateTestDataCommand < BaseCommand
  def execute
    users
    fitness_models
    wishlist_models
  end

  private

  def fitness_models
    workout_tags
    exercise_type_tags
    workouts
    equipment
    exercise_types
    exercises
    exercise_sets
    gyms
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
    @workout_tags ||= {
      dev.id => [
        seed(
          WorkoutTag,
          find_by: { name: "Legs", user: dev },
        ),
        seed(
          WorkoutTag,
          find_by: { name: "Chest", user: dev },
        ),
      ],
      dev2.id => [
        seed(
          WorkoutTag,
          find_by: { name: "Chest for user 2", user: dev2 },
        ),
      ],
    }
  end

  def exercise_type_tags
    @exercise_type_tags ||= {
      dev.id => [
        seed(
          ExerciseTypeTag,
          find_by: { name: "Biceps", user: dev },
        ),
        seed(
          ExerciseTypeTag,
          find_by: { name: "Triceps", user: dev },
        ),
      ],
      dev2.id => [
        seed(
          ExerciseTypeTag,
          find_by: { name: "Chest", user: dev2 },
        ),
        seed(
          ExerciseTypeTag,
          find_by: { name: "Legs", user: dev2 },
        ),
      ],
    }
  end

  def exercise_types
    @exercise_types ||= {
      dev.id => [
        seed(
          ExerciseType,
          find_by: { name: "Bicep Curl", user: dev },
          update: { equipment: [equipment[dev.id][:dumbbell]] },
        ),
        seed(
          ExerciseType,
          find_by: { name: "Tricep Extension", user: dev },
          update: { equipment: [equipment[dev.id][:dumbbell]] },
        ),
      ],
      dev2.id => [
        seed(
          ExerciseType,
          find_by: { name: "Bench Press", user: dev2 },
          update: { equipment: [equipment[dev2.id][:barbell]] },
        ),
        seed(
          ExerciseType,
          find_by: { name: "Shoulder Press", user: dev2 },
          update: { equipment: [equipment[dev2.id][:barbell]] },
        ),
      ],
    }
  end

  def workouts
    @workouts ||= {
      dev.id => [
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
      ],
    }
  end

  def exercises
    @exercises ||= [
      seed(
        Exercise,
        find_by: { exercise_type: exercise_types[dev.id].first, workout: workouts[dev.id].first },
        update: { note: "Used straps, and failed the last rep" },
      ),
      seed(
        Exercise,
        find_by: { exercise_type: exercise_types[dev.id].second, workout: workouts[dev.id].first },
        update: { note: "Used straps, and failed the last rep" },
      ),
    ]
  end

  def exercise_sets
    @exercise_sets ||= begin
      exercise_sets = []
      exercises.each do |exercise|
        exercise_sets += [
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
      exercise_sets
    end
  end

  def wishlists
    @wishlists ||= {
      dev.id => [
        seed(
          Wishlist,
          find_by: { name: "Christmas", user: dev },
        ),
        seed(
          Wishlist,
          find_by: { name: "Birthday", user: dev },
        ),
      ],
      dev2.id => [
        seed(
          Wishlist,
          find_by: { name: "Christmas", user: dev2 },
        ),
        seed(
          Wishlist,
          find_by: { name: "Birthday", user: dev2 },
        ),
      ],
    }
  end

  def wishlist_items
    @wishlist_items ||= begin
      wishlist_items = []
      wishlists.values.flatten.each do |wishlist|
        wishlist_items += [
          seed(
            WishlistItem,
            find_by: { wishlist:, name: "Thing 1" },
            update: { price: 12.34, description: "This is a description" },
          ),
          seed(
            WishlistItem,
            find_by: { wishlist:, name: "Thing 2" },
            update: { price: 78.00, description: "This is another description" },
          ),
        ]
      end
      wishlist_items
    end
  end

  def wishlist_item_links
    @wishlist_item_links ||= begin
      wishlist_item_links = []
      wishlist_items.each do |wishlist_item|
        wishlist_item_links += [
          seed(
            Link,
            find_by: { linkable: wishlist_item, url: "https://www.google.com" },
          ),
        ]
      end
      wishlist_item_links
    end
  end

  def gyms
    @gyms ||= {
      dev.id => [
        seed(
          Gym,
          find_by: { name: "GoodLife Fitness", user: dev },
          update: { equipment: equipment[dev.id].values },
        ),
        seed(
          Gym,
          find_by: { name: "LA Fitness", user: dev },
          update: { equipment: equipment[dev.id].values },
        ),
      ],
      dev2.id => [
        seed(
          Gym,
          find_by: { name: "Condo Gym", user: dev2 },
          update: { equipment: equipment[dev2.id].values },
        ),
        seed(
          Gym,
          find_by: { name: "Altea Active", user: dev2 },
          update: { equipment: equipment[dev2.id].values },
        ),
      ],
    }
  end

  def equipment
    @equipment ||= {
      dev.id => {
        dumbbell: seed(
          Equipment,
          find_by: { name: "Dumbbell", user: dev },
        ),
        barbell: seed(
          Equipment,
          find_by: { name: "Barbell", user: dev },
        ),
      },
      dev2.id => {
        dumbbell: seed(
          Equipment,
          find_by: { name: "Dumbbell", user: dev2 },
        ),
        barbell: seed(
          Equipment,
          find_by: { name: "Barbell", user: dev2 },
        ),
      },
    }
  end
end
# rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Metrics/ClassLength
